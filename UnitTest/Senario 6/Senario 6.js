const ZarelaSmartContract = artifacts.require("ZarelaSmartContract");
const MockClock = artifacts.require("MockClock");


contract('ZarelaSmartContract', (accounts) => {

  it('should transfer token to contributor', async()=> {
    const instance = await ZarelaSmartContract.deployed();
    const mockClock = await MockClock.deployed();
    await instance.submitNewRequest('_orderTitle','_description','_zPaper',20000000000, 40000000000 ,100,'EEG',1,{from: accounts[0]});
    await instance.contribute(0,accounts[1],accounts[2],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[1]});
    await instance.contribute(0,accounts[1],accounts[2],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[1]});
    await instance.contribute(0,accounts[1],accounts[2],false,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[2]});
    await instance.contribute(0,accounts[1],accounts[2],false,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[2]});

    await mockClock.addOneDay();

    await instance.contribute(0,accounts[4],accounts[5],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[4]});


    await instance.confirmContributor(0,[0,1,2,3],{from:accounts[0]});

    const balanceAcc01 = await instance.balanceOf(accounts[1]);
    const balanceAcc02 = await instance.balanceOf(accounts[2]);



    assert.equal(balanceAcc01,180000000000);
    assert.equal(balanceAcc02,260000000000);

  });

});
