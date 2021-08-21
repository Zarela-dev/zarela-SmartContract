const ZarelaSmartContract = artifacts.require("ZarelaSmartContract");
const MockClock = artifacts.require("MockClock");


contract('ZarelaSmartContract', (accounts) => {

  it('should transfer token to contributor', async()=> {
    const instance = await ZarelaSmartContract.deployed();
    const mockClock = await MockClock.deployed();
    await instance.submitNewRequest('_orderTitle','_description','_zPaper',20,0,100,'EEG',1,{from: accounts[0]});
    for(let i=0 ; i < 4 ; i++){
      await instance.contribute(0,accounts[1],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[1]});
    }
    const balanceAccount1_Before = await instance.balanceOf(accounts[1]);
    const bankBalanceDay0 = await instance.bankBalance();
    await mockClock.addOneDay();
    for(let i=0 ; i < 8 ; i++){
      await instance.contribute(0,accounts[2],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[2]});
      if(i==0){
        var balanceAccount1_After = await instance.balanceOf(accounts[1]);
      }
    }
    const bankBalanceDay1 = await instance.bankBalance();
    await mockClock.addOneDay();
    const balanceAccount2_Before = await instance.balanceOf(accounts[2]);
    for(let i=0 ; i < 4 ; i++){
      await instance.contribute(0,accounts[3],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[3]});
      if(i==0){
        var balanceAccount2_After = await instance.balanceOf(accounts[2]);
      }
    }
    const bankBalanceDay2 = await instance.bankBalance();
    await mockClock.addOneDay();
    const balanceAccount3_Before = await instance.balanceOf(accounts[3]);
    for(let i=0 ; i < 7 ; i++){
      await instance.contribute(0,accounts[4],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[4]});
      if(i==0){
        var balanceAccount3_After = await instance.balanceOf(accounts[3]);
      }
    }
    const bankBalanceDay3 = await instance.bankBalance();
    await mockClock.addOneDay();
    const balanceAccount4_Before = await instance.balanceOf(accounts[4]);
    for(let i=0 ; i < 3 ; i++){
      await instance.contribute(0,accounts[5],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[5]});
      if(i==0){
        var balanceAccount4_After = await instance.balanceOf(accounts[4]);
      }
    }
    const bankBalanceDay4 = await instance.bankBalance();
    await mockClock.addOneDay();
    const balanceAccount5_Before = await instance.balanceOf(accounts[5]);
    for(let i=0 ; i < 23 ; i++){
      await instance.contribute(0,accounts[6],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[6]});
      if(i==0){
        var balanceAccount5_After = await instance.balanceOf(accounts[5]);
      }
    }
    const bankBalanceDay5 = await instance.bankBalance();
    await mockClock.addOneDay();
    const balanceAccount6_Before = await instance.balanceOf(accounts[6]);
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[7],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[7]});
    }
    await mockClock.addOneDay();
    const balanceAccount7_Before = await instance.balanceOf(accounts[7]);
    for(let i=0 ; i < 10 ; i++){
      await instance.contribute(0,accounts[8],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[8]});
      if(i==0){
        var balanceAccount7_After = await instance.balanceOf(accounts[7]);
        var balanceAccount6_After = await instance.balanceOf(accounts[6]);
      }
    }
    await mockClock.addOneDay();
    const balanceAccount8_Before = await instance.balanceOf(accounts[8]);
    for(let i=0 ; i < 15 ; i++){
      await instance.contribute(0,accounts[9],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[9]});
      if(i==0){
        var balanceAccount8_After = await instance.balanceOf(accounts[8]);
      }
    }
    await mockClock.addOneDay();
    const balanceAccount9_Before = await instance.balanceOf(accounts[9]);
    for(let i=0 ; i < 6 ; i++){
      await instance.contribute(0,accounts[10],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[10]});
      if(i==0){
        var stateOfValue9 = await instance.balanceOf(accounts[9]);
        var balanceAccount9_After = await instance.balanceOf(accounts[9]);
      }
    }
    await mockClock.addOneDay();
    const balanceAccount10_Before = await instance.balanceOf(accounts[10]);
    for(let i=0 ; i < 10 ; i++){
      await instance.contribute(0,accounts[11],accounts[10],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[11]});
      if(i==0){
        var balanceAccount10_After = await instance.balanceOf(accounts[10]);
      }
    }


    assert.equal(balanceAccount1_Before,0);
    assert.equal(balanceAccount1_After,200000000000);
    assert.equal(balanceAccount2_Before,0);
    assert.equal(balanceAccount2_After,400000000000);
    assert.equal(balanceAccount3_Before,0);
    assert.equal(balanceAccount3_After,200000000000);
    assert.equal(balanceAccount4_Before,0);
    assert.equal(balanceAccount4_After,350000000000);
    assert.equal(balanceAccount5_Before,0);
    assert.equal(balanceAccount5_After,150000000000);
    assert.equal(balanceAccount6_Before,0);
    assert.equal(balanceAccount6_After,1150000000000);
    assert.equal(balanceAccount7_Before,0);
    assert.equal(balanceAccount7_After,100000000000);
    assert.equal(balanceAccount8_Before,0);
    assert.equal(balanceAccount8_After,500000000000);
    assert.equal(balanceAccount9_Before,0);
    assert.equal(stateOfValue9,50000000000);
    assert.equal(balanceAccount9_After,50000000000);
    assert.equal(balanceAccount10_Before,0);
    assert.equal(balanceAccount10_After,300000000000);
    assert.equal(bankBalanceDay0,0);
    assert.equal(bankBalanceDay1,14200000000000);
    assert.equal(bankBalanceDay2,28200000000000);
    assert.equal(bankBalanceDay3,42400000000000);
    assert.equal(bankBalanceDay4,42250000000000);
    assert.equal(bankBalanceDay5,42500000000000);

  });


});
