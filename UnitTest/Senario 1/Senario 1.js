const ZarelaSmartContract = artifacts.require("ZarelaSmartContract");
const MockClock = artifacts.require("MockClock");


contract('ZarelaSmartContract', (accounts) => {


  it('should confirm contributors and send their token', async()=> {
    const instance = await ZarelaSmartContract.deployed();
    const mockClock = await MockClock.deployed();
    await instance.submitNewRequest('_orderTitle','_description','_zPaper',20000000000,40000000000,100,'EEG',1,{from: accounts[0]});
    await instance.contribute(0,accounts[1],accounts[2],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[1]});
    for(let i = 0 ; i < 144 ; i++){
      await instance.contribute(0,accounts[1],accounts[2],false,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[2]});
    }
    for(let j = 0 ; j < 3 ; j++){
      await instance.contribute(0,accounts[4],accounts[5],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[4]});

    }
    await instance.confirmContributor(0,[0,1,2,3,4,5,6,7,8,9]);
    await mockClock.addOneDay();

    await instance.contribute(0,accounts[6],accounts[7],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[6]});
    const firstValueAcc02 = await instance.balanceOf(accounts[2]);
    await instance.contribute(0,accounts[8],accounts[9],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[8]});
    const firstValueAcc01 = await instance.balanceOf(accounts[1]);
    const secondValueAcc02 = await instance.balanceOf(accounts[2]);


    await mockClock.addOneDay();

    await instance.contribute(0,accounts[8],accounts[9],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[8]});
    await instance.contribute(0,accounts[8],accounts[9],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[8]});
    const thirdValueAcc02 = await instance.balanceOf(accounts[2]);
    const firstValueAcc03 = await instance.balanceOf(accounts[3]);


    assert.equal(firstValueAcc02,400000000000);
    assert.equal(secondValueAcc02,450000000000);
    assert.equal(thirdValueAcc02,3650000000000);
    assert.equal(firstValueAcc01,250000000000);
    assert.equal(firstValueAcc03,0);

  });


});
