if (typeof web3 !== 'undefined') {
            web3 = new Web3(web3.currentProvider);
        } else {
            // set the provider you want from Web3.providers
            web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:5000"));
        }


        $("#s1").attr("value", web3.eth.accounts[1]);
        $("#s2").attr("value", web3.eth.accounts[2]);

        var supplyChain = web3.eth.contract([{"constant":false,"inputs":[{"name":"from","type":"address"},{"name":"to","type":"address"},{"name":"receiptID","type":"bytes32"},{"name":"amount","type":"uint256"},{"name":"signTime","type":"uint256"},{"name":"endTime","type":"uint256"}],"name":"transferReceipt","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalFinancingAmount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"payDebt","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"role","type":"uint8"},{"name":"userAddr","type":"address"}],"name":"getBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"receiptID","type":"bytes32"},{"name":"signTime","type":"uint256"},{"name":"amount","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"supplierAddr","type":"address"}],"name":"signReceipt","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"}],"name":"financing","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"id","type":"bytes32"},{"name":"name","type":"string"},{"name":"balance","type":"uint256"},{"name":"role","type":"uint8"}],"name":"addUser","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"}]);
        var sc = supplyChain.at('0x250d4119b9a15e1d668737c0bcfcf4bff0764dc1');

        $("#add").click(function() {
            var currAccount = $("select").find("option:selected").attr("value");
            sc.financing.sendTransaction($("#amount").val(), {from:currAccount}, function(error, addr) {
				if (!error) alert("Financing Succeed.");
				else alert(error.toString());
			});
        });
        
        $("#back").click(function() {
            window.location.href="test.html";
        });