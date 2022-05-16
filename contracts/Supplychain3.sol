pragma solidity ^0.4.20;

contract SupplyChain3 {
    struct Company {
        address company;   // ��˾
        uint amount;      // ��˾���˶���Ǯ
    }
    
    struct Receipt {
        address sourceNode; // Ӧ���˿�ݵ�Ƿ�
        uint identifier;  // �˵���Ӧ���˵���
        uint oweAmount;    // Ƿ����
        Company[] companyList;
    }
    
    mapping(address => Company[]) nodes; // ��Company��Receipt�н���һ��ӳ��
    
    // ����һ���ɹ���Ʒ-ǩ��Ӧ���˿������������һ��Receipt�����ܲ�ѯ��Receipt�е�Ƿ����
	//����һ�����˵�
    function addReceipt(address to, uint identifier, uint oweAmount) public {
        Receipt[] storage receiptList = nodes[to];//����һ���˵��б�,to��ʾǷ��������˶���
		//�����˵����Ƿ�ʹ�ù�
        for (uint i = 0; i < receiptList.length; ++i) {
            require(!(msg.sender == receiptList[i].sourceNode && identifier == receiptList[i].identifier), "���˵����ظ���������");
        }
        Receipt storage receipt;
        receipt.sourceNode = msg.sender;
        receipt.identifier = identifier;
        receipt.oweAmount = oweAmount;
        receiptList.push(receipt);
    }
    
	//��ѯ�˵��е�Ƿ����
    function getReceiptAmount(address from, address to, uint identifier) public view returns(uint) {
        Receipt[] storage receiptList = nodes[to];
        for (uint i = 0; i < receiptList.length; ++i) {
            if (receiptList[i].sourceNode == from && receiptList[i].identifier == identifier) {
                return receiptList[i].oweAmount;
            }
        }
        require(false, "�˵��Ŵ������������룡");
    }
    
    // ���ܶ���Ӧ���˿��ת��������B��˾��C��˾Ҫ��һ��������B��˾�ɽ���Ӧ����A��˾Ƿ���˵���A��˾ΪǷ�����C��˾����ôC��˾��ƾ���˵���A��˾ҪB��˾������Ǯ
    function transferReceipt(address from, uint Identifier1, address to, uint16 Identifier2, uint64 splitAmount) public {
        require(splitValue > 0, "ת�ý��������0");
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
        require(found, "�˵��Ŵ������������룡");
         // ����B��˾�ж���Ǯ����ת��
        Receipt storage receipt = receiptList[index];
        uint sum = 0;
        Company[] storage companyList = receipt.companyList;
        for (i = 0; i < companyList.length; ++i) {
            sum += companyList[i].amount;
        }
        uint left = receipt.oweAmount - sum;
        Receipt[] storage toList = nodes[to];
        for (i = 0; i < toList.length; ++i) {
            require(!(receipt.sourceNode == toList[i].sourceNode && Identifier2 == toList[i].identifier), "���˵����ظ���������");
        }
        
        // ����һ�����˵�����ʾ��ʱA��˾ͬʱǷB��˾��C��˾Ǯ
        Receipt storage newReceipt;
        newReceipt.sourceNode = receipt.sourceNode;  //��ͬ��Ƿ�
        newReceipt.identifier = Identifier2;
        newReceipt.oweAmount = splitAmount;
        toList.push(newReceipt);
        receipt.oweAmount -= splitAmount;
    }
    
    // ������������Ӧ���˿������������������˵��е��տ�ɸ����˵������н��
    function bankFinancing(address from, uint16 Identifier1, address to, uint64 amount) public {
        require(value > 0, "amount�������0");
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
        require(found, "�˵��Ŵ������������룡");
        
        // �Ƚϸù�˾����������ӵ�е�Ƿ���
        Receipt storage receipt = list[index];
        uint sum = 0;
        Company[] storage companyList = receipt.companyList;
        for (i = 0; i < companyList.length; ++i) {
            sum += companyList[i].amount;
        }
        uint left = receipt.oweAmount - sum;
        require(left >= amount, "�ù�˾��������������ӵ�е�Ƿ���");
        
        //���ù�˾������������
		Company storage thiscompany;
        thiscompany.company = msg.sender;
        thiscompany.amount = amount;
        receipt.companyList.push(thiscompany);
    }
    
    // �����ģ�Ӧ���˿�֧������������Ӧ���˿�ݵ���ʱ������ҵ��������ҵ֧����Ӧ��Ƿ��
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
        require(found, "�˵��Ŵ������������룡");
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
        require(found, "��˾�������������룡");
    }
}