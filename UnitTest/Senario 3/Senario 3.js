const ZarelaSmartContract = artifacts.require("ZarelaSmartContract");
const MockClock = artifacts.require("MockClock");


contract('ZarelaSmartContract', (accounts) => {

  it('should transfer token 1-1 at first then 1-32', async()=> {
    const instance = await ZarelaSmartContract.deployed();
    const mockClock = await MockClock.deployed();
    await instance.submitNewRequest('_orderTitle','_description','_zPaper',30000000000,50000000000,100,'EEG',1,{from: accounts[0]});

    for( let i=0 ; i < 50 ; i++){
      await instance.contribute(0,accounts[1],accounts[7],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[1]});
    }
    await mockClock.addOneDay();
    await instance.contribute(0,accounts[2],accounts[7],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[2]});
    const firstValueAcc01 = await instance.balanceOf(accounts[1]);
    await mockClock.addOneDay();
    await instance.contribute(0,accounts[3],accounts[7],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[3]});
    const secondValueAcc01 = await instance.balanceOf(accounts[1]);
    await instance.contribute(0,accounts[4],accounts[7],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[4]});
    const thirdValueAcc01 = await instance.balanceOf(accounts[1]);


    const valueAcc02 = await instance.balanceOf(accounts[2]);
    const valueAcc03 = await instance.balanceOf(accounts[3]);
    const valueAcc04 = await instance.balanceOf(accounts[4]);

    assert.equal(firstValueAcc01,50000000000);
    assert.equal(secondValueAcc01,1650000000000);
    assert.equal(thirdValueAcc01,2500000000000);
    assert.equal(valueAcc02,50000000000);
    assert.equal(valueAcc03,0);
    assert.equal(valueAcc04,0);


  });


});
