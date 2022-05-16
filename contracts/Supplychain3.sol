pragma solidity ^0.4.20;

contract SupplyChain3 {
    struct Company {
        address company;   // 借款公司
        uint amount;      // 借款公司借了多少钱
    }
    
    struct Receipt {
        address sourceNode; // 应收账款单据的欠款方
        uint identifier;  // 账单对应的账单号
        uint oweAmount;    // 欠款金额
        Company[] companyList;
    }
    
    mapping(address => Company[]) nodes; // 在Company和Receipt中建立一个映射
    
    // 功能一：采购商品-签发应收账款交易上链，生成一个Receipt，并能查询该Receipt中的欠款金额
	//生成一个新账单
    function addReceipt(address to, uint identifier, uint oweAmount) public {
        Receipt[] storage receiptList = nodes[to];//生成一个账单列表,to表示欠款方，被给了东西
		//检查该账单号是否被使用过
        for (uint i = 0; i < receiptList.length; ++i) {
            require(!(msg.sender == receiptList[i].sourceNode && identifier == receiptList[i].identifier), "该账单号重复，不可用");
        }
        Receipt storage receipt;
        receipt.sourceNode = msg.sender;
        receipt.identifier = identifier;
        receipt.oweAmount = oweAmount;
        receiptList.push(receipt);
    }
    
	//查询账单中的欠款金额
    function getReceiptAmount(address from, address to, uint identifier) public view returns(uint) {
        Receipt[] storage receiptList = nodes[to];
        for (uint i = 0; i < receiptList.length; ++i) {
            if (receiptList[i].sourceNode == from && receiptList[i].identifier == identifier) {
                return receiptList[i].oweAmount;
            }
        }
        require(false, "账单号错误，请重新输入！");
    }
    
    // 功能二：应收账款的转让上链。B公司从C公司要了一批东西，B公司可将相应的与A公司欠款账单（A公司为欠款方）给C公司，那么C公司可凭该账单向A公司要B公司买东西的钱
    function transferReceipt(address from, uint Identifier1, address to, uint16 Identifier2, uint64 splitAmount) public {
        require(splitValue > 0, "转让金额必须大于0");
        uint i = 0;
        uint index = 0;
        bool found = false;
        Receipt[] storage receiptList = nodes[msg.sender];
        for (i = 0; i < receiptList.length; ++i) {
            if (receiptList[i].sourceNode == sender && receiptList[i].identifier == Identifier1) {
                found = true;
                index = i;
                break;
            }
        }
        require(found, "账单号错误，请重新输入！");
         // 计算B公司有多少钱可以转让
        Receipt storage receipt = receiptList[index];
        uint sum = 0;
        Company[] storage companyList = receipt.companyList;
        for (i = 0; i < companyList.length; ++i) {
            sum += companyList[i].amount;
        }
        uint left = receipt.oweAmount - sum;
        Receipt[] storage toList = nodes[to];
        for (i = 0; i < toList.length; ++i) {
            require(!(receipt.sourceNode == toList[i].sourceNode && Identifier2 == toList[i].identifier), "该账单号重复，不可用");
        }
        
        // 生成一个新账单，表示此时A公司同时欠B公司和C公司钱
        Receipt storage newReceipt;
        newReceipt.sourceNode = receipt.sourceNode;  //相同的欠款方
        newReceipt.identifier = Identifier2;
        newReceipt.oweAmount = splitAmount;
        toList.push(newReceipt);
        receipt.oweAmount -= splitAmount;
    }
    
    // 功能三：利用应收账款向银行融资上链，账单中的收款方可根据账单向银行借款
    function bankFinancing(address from, uint16 Identifier1, address to, uint64 amount) public {
        require(value > 0, "amount必须大于0");
        uint index = 0;
        uint i = 0;
        bool found = false;
        Receipt[] storage list = nodes[to];
        for (i = 0; i < list.length; ++i) {
            if (list[i].sourceNode == from && list[i].identifier == Identifier1) {
                index = i;
                found = true;
                break;
            }
        }
        require(found, "账单号错误，请重新输入！");
        
        // 比较该公司的所需借款额和拥有的欠款额
        Receipt storage receipt = list[index];
        uint sum = 0;
        Company[] storage companyList = receipt.companyList;
        for (i = 0; i < companyList.length; ++i) {
            sum += companyList[i].amount;
        }
        uint left = receipt.oweAmount - sum;
        require(left >= amount, "该公司的所需借款额大于其拥有的欠款额");
        
        //若该公司符合融资条件
		Company storage thiscompany;
        thiscompany.company = msg.sender;
        thiscompany.amount = amount;
        receipt.companyList.push(thiscompany);
    }
    
    // 功能四：应收账款支付结算上链，应收账款单据到期时核心企业向下游企业支付相应的欠款
    function payBack(address from, uint Identifier1, address to, uint amount) public {
        uint index = 0;
        uint i = 0;
        bool found = false;
        Receipt[] storage list = nodes[to];
        for (i = 0; i < list.length; ++i) {
            if (list[i].sourceNode == from && list[i].identifier == Identifier1) {
                index = i;
                found = true;
                break;
            }
        }
        require(found, "账单号错误，请重新输入！");
        Receipt storage receipt = list[index];
        Company[] storage companyList = receipt.companyList;
        found = false;
        for (int i = 0; i < companyList.length; ++i) {
            if (companyList[i].provider == msg.sender) {
                index = i;
                found = true;
                break;
            }
        }
        require(found, "公司错误，请重新输入！");
    }
}