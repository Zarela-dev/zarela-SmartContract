const ZarelaSmartContract = artifacts.require("ZarelaSmartContract");
const MockClock = artifacts.require("MockClock");


contract('ZarelaSmartContract', (accounts) => {

  it('should transfer token in condition of queue < 16 ', async()=> {
    const instance = await ZarelaSmartContract.deployed();
    const mockClock = await MockClock.deployed();
    await instance.submitNewRequest('_orderTitle','_description','_zPaper',50000000000,50000000000,100,'EEG',1,{from: accounts[0]});
    await instance.contribute(0,accounts[1],accounts[6],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[1]});
    await instance.contribute(0,accounts[2],accounts[6],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[2]});
    await instance.contribute(0,accounts[3],accounts[6],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[3]});
    await instance.contribute(0,accounts[4],accounts[6],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[4]});
    await mockClock.addOneDay();
    await instance.contribute(0,accounts[5],accounts[6],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[5]});

    const valueAcc1 = await instance.balanceOf(accounts[1]);
    const valueAcc2 = await instance.balanceOf(accounts[2]);
    const valueAcc3 = await instance.balanceOf(accounts[3]);
    const valueAcc4 = await instance.balanceOf(accounts[4]);


    assert.equal(valueAcc1,50000000000);
    assert.equal(valueAcc2,50000000000);
    assert.equal(valueAcc3,50000000000);
    assert.equal(valueAcc4,50000000000);


  });


});
