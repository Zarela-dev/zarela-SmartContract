// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0 <0.8.0;
import "./ERC20.sol";
import "./ERC20Burnable.sol";
contract ZarelaSmartContract is ERC20 , ERC20Burnable {
    constructor() {
        _mint(msg.sender , 4000000000000000); 
        _mint(address(this) , 16000000000000000);
    }

    event OrderRegistered(address owner , uint Order_ID);
    event Contributed(address Contributer , uint Order_ID , address Requester , uint difficulty);
    event OrderFinish(uint Order_ID);
    event Confirmation(address User);

    address payable[] public array_of_addresses;
    uint public halving;
    uint public timer_24Hour = block.timestamp;
    uint public timer_18month;
    uint public NextEntry;
    uint public Awarded;
    uint public Last_allowed;
    address nextone;
    uint public day_pay;
    uint public today_contribute;
    uint[] public contribute_count_daily;
    uint public ZarelaReward = 50000000000;
    uint public total_bank;
    uint public release = 14400000000000;
    uint SeeZero;
    uint[] public daily_Remain;
    uint public day_burner;
    uint public day_sequencer;
    uint[] public token_burn;
    uint[] public Daily_Prizes;
    uint[] public balance_bank_today;
    uint public difficulty;
    bool public Zarela_End;
    
    struct OrderFile{
        uint Order_ID;
        string Title;
        address Requester_Address_Creator;
        uint Token_Pay;
        uint Instance_Count;
        string White_Paper;
        string Description;
        uint Instance_Remains;
        uint Order_Contribute_Count;
        uint Registered_Time;
        string Ecrypted; 
    }
    
    struct Category{
        uint Order_ID;
        string Zarela_Category;
        uint Business_Category;
    }
    
    struct Data{
        uint Order_Number;
        uint[] Signal_Registered_Time;
        string[] Data;
        address[] Contributer_address;
        bool[] is_confirmed;
        uint[] zarela_day;
    }
    
    struct User{
        uint Token_Gained_from_SC;
        uint Token_Gained_from_Requester;
        uint[] orders_contributed;
        uint[] Order_Owned;
    }
    
    
    mapping(uint => Data) public Data_Map;
    mapping(address=>User) public User_Map;
    OrderFile[]public ord_file;
    Category[]public Cat;
    
    modifier OnlyRequester(uint _Order_Number){
        OrderFile storage myorder = ord_file[_Order_Number];
        require(myorder.Requester_Address_Creator == msg.sender, "You Are Not Owner");
        _;
    }
    
    modifier CheckID(uint _Order_Number){
        OrderFile storage myorder = ord_file[_Order_Number];
        require(_Order_Number == myorder.Order_ID , "This Order Number Is Not Correct");
        _;
    }
    
    modifier Notnull(address _address){
        require(address(0) != _address, "Send to the zero address");
        _;
    }
    
    function SetOrderBoard(string memory _Title,string memory _Description,string memory _White_Paper,uint _Token_Pay,uint _Instance_Count,string memory _Zarela_Category,string memory _Encrypted,uint _business_Category)public {
        require(_balances[msg.sender] >= (_Token_Pay*_Instance_Count) , "Your Token Is Not Enough");
        ERC20.transfer(address(this),(_Token_Pay*_Instance_Count));
        uint order_id = ord_file.length;
        ord_file.push(OrderFile(order_id,_Title,msg.sender,_Token_Pay,_Instance_Count,_White_Paper,_Description,_Instance_Count,0,block.timestamp,_Encrypted));
        User_Map[msg.sender].Order_Owned.push(order_id);
        Cat.push(Category(order_id,_Zarela_Category,_business_Category));
        emit OrderRegistered(msg.sender, order_id);
        emit Transfer(msg.sender,address(this),(_Token_Pay*_Instance_Count));
    }
    
    function SendFile(uint _Order_Number,  address _Requester , string memory _Data)public CheckID(_Order_Number) Notnull(_Requester) {
        require(ord_file[_Order_Number].Instance_Remains != 0 ,"Order Was Finished");
        require(_Requester ==  ord_file[_Order_Number].Requester_Address_Creator , "Requester Address Was Not Entered Correctly");
        if(Zarela_End != true){
            if(block.timestamp < timer_24Hour + 24 hours){
                array_of_addresses.push(msg.sender);
                today_contribute++;
            }
            else {
                array_of_addresses.push(address(0));
                array_of_addresses.push(msg.sender);
                contribute_count_daily.push(today_contribute);
                if(_balances[address(this)] >= release ){
                    _balances[address(this)] = _balances[address(this)] - release;
                }
                else if (total_bank > 0 && _balances[address(this)] < release) {
                   total_bank+= release;
                   release = 0;
                }
                else {
                    release = 0;
                    Zarela_End = true;
                }
                total_bank+=(release);
                daily_Remain.push(release);
                balance_bank_today.push(total_bank);
                if(ZarelaReward * contribute_count_daily[day_sequencer] >= total_bank){
                    balance_bank_today[day_sequencer] = total_bank;
                    Daily_Prizes.push(total_bank/contribute_count_daily[day_sequencer]);
                    total_bank = 0;
                }
                else{
                    balance_bank_today[day_sequencer] = ZarelaReward * contribute_count_daily[day_sequencer];
                    Daily_Prizes.push(ZarelaReward);
                    total_bank = total_bank - (ZarelaReward * contribute_count_daily[day_sequencer]);
                }
               
                uint temp_price = balance_bank_today[day_sequencer];
                if(temp_price >= daily_Remain[day_sequencer]){
                    temp_price = temp_price - (daily_Remain[day_sequencer]);
                    daily_Remain[day_sequencer] = 0;
                    while(temp_price > 0){
                        if(temp_price > daily_Remain[SeeZero]){
                            temp_price = temp_price - (daily_Remain[SeeZero]);
                            daily_Remain[SeeZero] = 0;
                            SeeZero++;
                        }
                        else{
                            daily_Remain[SeeZero] =  daily_Remain[SeeZero] - (temp_price);
                            temp_price = 0;
                        }
                    }
                }
                else{
                    daily_Remain[day_sequencer] = daily_Remain[day_sequencer] - temp_price;
                }
                difficulty = (Last_allowed - Awarded) / contribute_count_daily[day_sequencer];
                if((day_sequencer - day_pay) >= 7 && (Last_allowed - Awarded) >= 384 ){
                    difficulty = 128;
                }
                else if(difficulty < 5){
                    difficulty = 2**difficulty;
                }
                else{
                    difficulty = 32;
                }
                
                today_contribute = 0;
                day_sequencer++;
                timer_18month++;
                timer_24Hour = block.timestamp;
    
                if(day_sequencer > 45){ // 45 days
                    total_bank = total_bank - (daily_Remain[day_burner]);
                    token_burn.push(daily_Remain[day_burner]);
                    daily_Remain[day_burner] = 0;
                    day_burner++;
                }
                if(timer_18month > 547 ){
                    ZarelaReward = ZarelaReward / 2 ;
                    release = release / 2 ;
                    halving++;
                    timer_18month = 0 ;
                }
                
            }
            if (array_of_addresses[NextEntry] == address(0)){
                Last_allowed = NextEntry;
                reward();
                NextEntry+=2;
                today_contribute++;
            }
            else if (Last_allowed != Awarded){
                reward();
                NextEntry++;
            }
            else {
                NextEntry++;
            }
            
        }
        Data_Map[_Order_Number].Order_Number = _Order_Number;
        ord_file[_Order_Number].Order_Contribute_Count++;
        Data_Map[_Order_Number].Data.push(_Data);
        Data_Map[_Order_Number].Contributer_address.push(msg.sender);
        Data_Map[_Order_Number].is_confirmed.push(false);
        Data_Map[_Order_Number].Signal_Registered_Time.push(block.timestamp);
        User_Map[msg.sender].orders_contributed.push(_Order_Number);
        Data_Map[_Order_Number].zarela_day.push(day_sequencer);

        emit Contributed(msg.sender , _Order_Number , _Requester , difficulty);
    }
    
    function reward()private {
        uint temporary = Awarded;
        if(difficulty == 128){
            for(uint i= temporary; i < temporary + difficulty; i++){
                if(i >= Last_allowed ){
                    break;
                }
                nextone = array_of_addresses[i];
                if(nextone == address(0)){
                    day_pay++;
                    i++;
                    Awarded++;
                    nextone = array_of_addresses[i];
                }
                _balances[nextone] = _balances[nextone] + ((Daily_Prizes[day_pay]));
                User_Map[nextone].Token_Gained_from_SC+=(Daily_Prizes[day_pay]);
                Awarded++;
            }
        }
        if ((Last_allowed - temporary) >= 16){
            for(uint i = temporary  ; i < difficulty + temporary ; i++){
                if(i >= Last_allowed ){
                    break;
                }
                nextone = array_of_addresses[i];
                if(nextone == address(0)){
                    day_pay++;
                    i++;
                    Awarded++;
                    nextone = array_of_addresses[i];
                }
                _balances[nextone] = _balances[nextone] + ((Daily_Prizes[day_pay]));
                User_Map[nextone].Token_Gained_from_SC+=(Daily_Prizes[day_pay]);
                Awarded++;
            }
        }
        else if((Last_allowed - temporary) < 16 ){
            for(uint i = temporary ; i < Last_allowed ; i++){
                nextone = array_of_addresses[i];
                if(nextone == address(0)){
                    day_pay++;
                    i++;
                    Awarded++;
                    nextone = array_of_addresses[i];
                }
                _balances[nextone] = _balances[nextone] + ((Daily_Prizes[day_pay]));
                User_Map[nextone].Token_Gained_from_SC+=(Daily_Prizes[day_pay]);
                Awarded++;
                
            }
        }
        
    }
    
    
    function ConfirmContributer(uint _Order_Number,uint[]memory _Index)public OnlyRequester(_Order_Number) CheckID(_Order_Number) {
        OrderFile storage myorder = ord_file[_Order_Number];
        require(_Index.length <= myorder.Instance_Remains,"The number of entries is more than allowed");
        require(myorder.Instance_Remains != 0,"Your Order Is Done, And You Sent All of Rewards to Users");
        myorder.Instance_Remains = myorder.Instance_Remains - (_Index.length);
        for(uint i;i < _Index.length ; i++){
            _balances[address(this)] = _balances[address(this)] - (myorder.Token_Pay);
            _balances[Data_Map[_Order_Number].Contributer_address[_Index[i]]] = _balances[Data_Map[_Order_Number].Contributer_address[_Index[i]]] + (myorder.Token_Pay);
            User_Map[Data_Map[_Order_Number].Contributer_address[_Index[i]]].Token_Gained_from_Requester+=(myorder.Token_Pay);
            Data_Map[_Order_Number].is_confirmed[_Index[i]] = true;
        }
        if (myorder.Instance_Remains == 0){
            emit OrderFinish(_Order_Number);
        }
    }
    
    function GetOrderFiles(uint _Order_Number)public CheckID(_Order_Number) view returns(address[] memory,uint[]memory,bool[]memory,uint[] memory){
        return(Data_Map[_Order_Number].Contributer_address,Data_Map[_Order_Number].Signal_Registered_Time,Data_Map[_Order_Number].is_confirmed,Data_Map[_Order_Number].zarela_day);
    }
    
    function ShowFile(uint _Order_Number)public OnlyRequester(_Order_Number) CheckID(_Order_Number) view returns(string[] memory){
        return(Data_Map[_Order_Number].Data);
    }
    
    function Order_Details()public view returns(uint[]memory _Order_Owned,uint[]memory _orders_contributed){
        return(User_Map[msg.sender].Order_Owned,User_Map[msg.sender].orders_contributed);
    }
    
    function OrderSize()public view returns(uint){
        return ord_file.length;
    }
}