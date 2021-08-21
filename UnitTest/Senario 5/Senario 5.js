const ZarelaSmartContract = artifacts.require("ZarelaSmartContract");
const MockClock = artifacts.require("MockClock");


contract('ZarelaSmartContract', (accounts) => {

  it('should transfer token to contributor', async()=> {
    const instance = await ZarelaSmartContract.deployed();
    const mockClock = await MockClock.deployed();
    await instance.submitNewRequest('_orderTitle','_description','_zPaper',20,0,100,'EEG',1,{from: accounts[0]});
    const halvingCounterDay0 = await instance.halvingCounter();
    const maxUserDailyRewardDay0 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily0 = await instance.totalTokenReleaseDaily();
    for(let i=0 ; i < 20 ; i++){
      await instance.contribute(0,accounts[1],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[1]});
    }
    await mockClock.addOneDay();
    for(let i=0 ; i < 20 ; i++){
      await instance.contribute(0,accounts[2],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[2]});
      if(i==0){
        var transferToAcc1 = await instance.balanceOf(accounts[1]);
      }
    }
    const halvingCounterDay1 = await instance.halvingCounter();
    const maxUserDailyRewardDay1 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily1 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 20 ; i++){
      await instance.contribute(0,accounts[3],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[3]});
      if(i==0){
        var transferToAcc2 = await instance.balanceOf(accounts[2]);
      }
    }
    const halvingCounterDay2 = await instance.halvingCounter();
    const maxUserDailyRewardDay2 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily2 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 20 ; i++){
      await instance.contribute(0,accounts[4],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[4]});
      if(i==0){
        var transferToAcc3 = await instance.balanceOf(accounts[3]);
      }
    }
    const halvingCounterDay3 = await instance.halvingCounter();
    const maxUserDailyRewardDay3 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily3 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 20 ; i++){
      await instance.contribute(0,accounts[5],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[5]});
      if(i==0){
        var transferToAcc4 = await instance.balanceOf(accounts[4]);
      }
    }
    const halvingCounterDay4 = await instance.halvingCounter();
    const maxUserDailyRewardDay4 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily4 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 20 ; i++){
      await instance.contribute(0,accounts[6],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[6]});
      if(i==0){
        var transferToAcc5 = await instance.balanceOf(accounts[5]);
      }
    }
    const halvingCounterDay5 = await instance.halvingCounter();
    const maxUserDailyRewardDay5 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily5 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[7],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[7]});
      if(i==0){
        var transferToAcc6 = await instance.balanceOf(accounts[6]);
      }
    }
    const halvingCounterDay6 = await instance.halvingCounter();
    const maxUserDailyRewardDay6 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily6 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[8],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[8]});
      if(i==0){
        var transferToAcc7 = await instance.balanceOf(accounts[7]);
      }
    }
    const halvingCounterDay7 = await instance.halvingCounter();
    const maxUserDailyRewardDay7 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily7 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[9],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[9]});
      if(i==0){
        var transferToAcc8 = await instance.balanceOf(accounts[8]);
      }
    }
    const halvingCounterDay8 = await instance.halvingCounter();
    const maxUserDailyRewardDay8 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily8 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[10],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[10]});
      if(i==0){
        var transferToAcc9 = await instance.balanceOf(accounts[9]);
      }
    }
    const halvingCounterDay9 = await instance.halvingCounter();
    const maxUserDailyRewardDay9 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily9 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[11],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[11]});
      if(i==0){
        var transferToAcc10 = await instance.balanceOf(accounts[10]);
      }
    }
    const halvingCounterDay10 = await instance.halvingCounter();
    const maxUserDailyRewardDay10 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily10 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[12],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[12]});
      if(i==0){
        var transferToAcc11 = await instance.balanceOf(accounts[11]);
      }
    }
    const halvingCounterDay11 = await instance.halvingCounter();
    const maxUserDailyRewardDay11 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily11 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[13],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[13]});
      if(i==0){
        var transferToAcc12 = await instance.balanceOf(accounts[12]);
      }
    }
    const halvingCounterDay12 = await instance.halvingCounter();
    const maxUserDailyRewardDay12 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily12 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[14],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[14]});
      if(i==0){
        var transferToAcc13 = await instance.balanceOf(accounts[13]);
      }
    }
    const halvingCounterDay13 = await instance.halvingCounter();
    const maxUserDailyRewardDay13 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily13 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    for(let i=0 ; i < 2 ; i++){
      await instance.contribute(0,accounts[15],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[15]});
      if(i==0){
        var transferToAcc14 = await instance.balanceOf(accounts[14]);
      }
    }
    const halvingCounterDay14 = await instance.halvingCounter();
    const maxUserDailyRewardDay14 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily14 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    await instance.contribute(0,accounts[16],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[16]});
    const transferToAcc15 = await instance.balanceOf(accounts[15]);
    const halvingCounterDay15 = await instance.halvingCounter();
    const maxUserDailyRewardDay15 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily15 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    await instance.contribute(0,accounts[17],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[17]});
    const transferToAcc16 = await instance.balanceOf(accounts[16]);
    const halvingCounterDay16 = await instance.halvingCounter();
    const maxUserDailyRewardDay16 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily16 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    await instance.contribute(0,accounts[18],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[18]});
    const transferToAcc17 = await instance.balanceOf(accounts[17]);
    const halvingCounterDay17 = await instance.halvingCounter();
    const maxUserDailyRewardDay17 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily17 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();
    await instance.contribute(0,accounts[19],accounts[20],true,accounts[0],'IPFSHash','EncryptionKey',{from:accounts[19]});
    const transferToAcc18 = await instance.balanceOf(accounts[18]);
    const halvingCounterDay18 = await instance.halvingCounter();
    const maxUserDailyRewardDay18 = await instance.maxUserDailyReward();
    const totalTokenReleaseDaily18 = await instance.totalTokenReleaseDaily();
    await mockClock.addOneDay();

    assert.equal(halvingCounterDay0,0);
    assert.equal(maxUserDailyRewardDay0,50000000000);
    assert.equal(totalTokenReleaseDaily0,14400000000000);
    assert.equal(halvingCounterDay1,0);
    assert.equal(maxUserDailyRewardDay1,50000000000);
    assert.equal(totalTokenReleaseDaily1,14400000000000);
    assert.equal(halvingCounterDay2,0);
    assert.equal(maxUserDailyRewardDay2,50000000000);
    assert.equal(totalTokenReleaseDaily2,14400000000000);
    assert.equal(halvingCounterDay3,0);
    assert.equal(maxUserDailyRewardDay3,50000000000);
    assert.equal(totalTokenReleaseDaily3,14400000000000);
    assert.equal(halvingCounterDay4,0);
    assert.equal(maxUserDailyRewardDay4,50000000000);
    assert.equal(totalTokenReleaseDaily4,14400000000000);
    assert.equal(halvingCounterDay5,0);
    assert.equal(maxUserDailyRewardDay5,50000000000);
    assert.equal(totalTokenReleaseDaily5,14400000000000);
    assert.equal(halvingCounterDay6,1);
    assert.equal(maxUserDailyRewardDay6,25000000000);
    assert.equal(totalTokenReleaseDaily6,7200000000000);
    assert.equal(halvingCounterDay7,1);
    assert.equal(maxUserDailyRewardDay7,25000000000);
    assert.equal(totalTokenReleaseDaily7,7200000000000);
    assert.equal(halvingCounterDay8,1);
    assert.equal(maxUserDailyRewardDay8,25000000000);
    assert.equal(totalTokenReleaseDaily8,7200000000000);
    assert.equal(halvingCounterDay9,1);
    assert.equal(maxUserDailyRewardDay9,25000000000);
    assert.equal(totalTokenReleaseDaily9,7200000000000);
    assert.equal(halvingCounterDay10,1);
    assert.equal(maxUserDailyRewardDay10,25000000000);
    assert.equal(totalTokenReleaseDaily10,7200000000000);
    assert.equal(halvingCounterDay11,2);
    assert.equal(maxUserDailyRewardDay11,12500000000);
    assert.equal(totalTokenReleaseDaily11,3600000000000);
    assert.equal(halvingCounterDay12,2);
    assert.equal(maxUserDailyRewardDay12,12500000000);
    assert.equal(totalTokenReleaseDaily12,3600000000000);
    assert.equal(halvingCounterDay13,2);
    assert.equal(maxUserDailyRewardDay13,12500000000);
    assert.equal(totalTokenReleaseDaily13,3600000000000);
    assert.equal(halvingCounterDay14,2);
    assert.equal(maxUserDailyRewardDay14,12500000000);
    assert.equal(totalTokenReleaseDaily14,3600000000000);
    assert.equal(halvingCounterDay15,2);
    assert.equal(maxUserDailyRewardDay15,12500000000);
    assert.equal(totalTokenReleaseDaily15,3600000000000);
    assert.equal(halvingCounterDay16,3);
    assert.equal(maxUserDailyRewardDay16,6250000000);
    assert.equal(totalTokenReleaseDaily16,1800000000000);
    assert.equal(halvingCounterDay17,3);
    assert.equal(maxUserDailyRewardDay17,6250000000);
    assert.equal(totalTokenReleaseDaily17,1800000000000);
    assert.equal(halvingCounterDay18,3);
    assert.equal(maxUserDailyRewardDay18,6250000000);
    assert.equal(totalTokenReleaseDaily18,1800000000000);


    assert.equal(transferToAcc1,50000000000);
    assert.equal(transferToAcc2,50000000000);
    assert.equal(transferToAcc3,50000000000);
    assert.equal(transferToAcc4,50000000000);
    assert.equal(transferToAcc5,50000000000);
    assert.equal(transferToAcc6,25000000000);
    assert.equal(transferToAcc7,50000000000);
    assert.equal(transferToAcc8,50000000000);
    assert.equal(transferToAcc9,50000000000);
    assert.equal(transferToAcc10,50000000000);
    assert.equal(transferToAcc11,25000000000);
    assert.equal(transferToAcc12,25000000000);
    assert.equal(transferToAcc13,25000000000);
    assert.equal(transferToAcc14,25000000000);
    assert.equal(transferToAcc15,25000000000);
    assert.equal(transferToAcc16,6250000000);
    assert.equal(transferToAcc17,6250000000);
    assert.equal(transferToAcc18,6250000000);


  });

});
