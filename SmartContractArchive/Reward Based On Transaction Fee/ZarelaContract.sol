// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0 <0.8.0;
import "./CheckPrice.sol";
import "./ERC20.sol";
import "./Tools.sol";
import "./SafeMath.sol";

contract ZarelaSmartContract is ERC20,CheckPrice {
    IERC20 private token;
    address payable public owner;
    constructor(IERC20 BioBit)ERC20("BioBit","BBit")  public {
        owner = msg.sender;
        _totalSupply = 20000000000000000;
        _balances[owner] = _totalSupply;
        token = BioBit;
    }
    using SafeMath for uint256;

    uint date = block.timestamp;

    struct Scientist{
        address Scientist_Address;
        uint Unique_ID;
    }
    struct Order{
        address Scientist_Address_Creator;
        uint Scientist_ID_Creator;
        uint Token_Pay;
        uint Instance_Count;
        string Area;
        string Description;
        // uint value;
        string Document_Of_Description;
        uint Instance_Remains;
    }
    struct Signals{
        uint Order_ID;
        string[] EEG_Signal_Hash;
    }
    Order[] public Ord;
    Scientist[] Scientists;
    Signals[] User_Signal;
    address[] daneshmand;
    mapping(uint=>address) public OrderToOwner;
    mapping(address=>uint) public OwnerOrderCount;
    mapping(uint=>Scientist)private Scientist_Map;
    mapping(uint=>Order)private Order_Map;
    mapping(uint=>Signals)public Signal_Map;


    function CalculateReward() public {
        uint return_money;
        if (date + 548 days > block.timestamp){
            return_money = uint(18/((CheckPrice.getThePrice()/10**9))+1);
            if(_balances[address(this)] >= return_money){
                _balances[address(this)] = _balances[address(this)]- (return_money);
                _balances[msg.sender] = _balances[msg.sender] + (return_money);
            }
        }
        else if (block.timestamp < date + 1095 days){
            return_money = uint((18/((CheckPrice.getThePrice()/10**9)+1))/2);
            if(_balances[address(this)] >= return_money){
            _balances[address(this)] = _balances[address(this)]- (return_money);
            _balances[msg.sender] = _balances[msg.sender] + (return_money);
            }
        }
        else if (block.timestamp < date + 1643 days){
            return_money = uint((18/((CheckPrice.getThePrice()/10**9)+1))/4);
            if(_balances[address(this)] >= return_money){
            _balances[address(this)] = _balances[address(this)]- (return_money);
            _balances[msg.sender] = _balances[msg.sender] + (return_money);
            }
        }
        else if (block.timestamp < date + 2190 days){
            return_money = uint((18/((CheckPrice.getThePrice()/10**9)+1))/8);
            if(_balances[address(this)] >= return_money){
            _balances[address(this)] = _balances[address(this)]- (return_money);
            _balances[msg.sender] = _balances[msg.sender] + (return_money);
            }
        }
        else{
            return_money = uint((18/((CheckPrice.getThePrice()/10**9)+1))/16);
            if(_balances[address(this)] >= return_money){
            _balances[address(this)] = _balances[address(this)]- (return_money);
            _balances[msg.sender] = _balances[msg.sender] + (return_money);
            }
        }
        emit Transfer(owner , msg.sender, return_money);
    }


    function GetScientistAddress(uint _Scientist_ID)public view returns(address){
        return (Scientist_Map[_Scientist_ID].Scientist_Address);
    }

    // Function 1 Login Scientist Be Zarela **Correct
    function Login()public payable{
        for (uint i; i < daneshmand.length ; i++){
            if( daneshmand[i] == msg.sender){
                require(2==5,"You Login Recently");
            }
        }
        daneshmand.push(msg.sender);
        uint ID = daneshmand.length.add(473);
        Scientist_Map[ID].Scientist_Address = msg.sender;
        Scientist_Map[ID].Unique_ID = ID;
        ScientistID[msg.sender] = ID;
    }


    // Function 2 Get ID For Scientist and User **Correct

       mapping(address=>uint) public ScientistID;
    //   mapping(address=>uint) public UserID;

    // Create Order Board is 3rd Step
    function ValueCalculate(uint _Instance_Count)public pure returns(uint){
        return SafeMath.mul( 0.0068 ether , _Instance_Count);
    } // We need Category like Open eyes , Close eyes , ....
    function CreateOrderBoard(uint _Scientist_ID,uint _Token_Pay,uint _Instance_Count,string memory _Area,
    string memory _Description,string memory _Document_Of_Description)public payable{
        require(_Scientist_ID != 0);
        require(ScientistID[msg.sender] == _Scientist_ID,"Wrong ID");
        // Tx Fee for all Contributers , 18 =  AVG Tx fee it will be calculate!!!
        // require(msg.value == SafeMath.mul( 0.0068 ether , _Instance_Count ),"Value is Incorrect");
        // Deposit Token for Contributers
        require(balanceOf(msg.sender) >= _Token_Pay,"You Dont Have Enough Token");
         Ord.push(Order(msg.sender,_Scientist_ID,_Token_Pay,_Instance_Count,_Area,_Description,
          _Document_Of_Description,_Instance_Count));
        uint id;
        id = Ord.length - 1 ;
        OrderToOwner[id] = msg.sender;
        OwnerOrderCount[msg.sender]++;
        Signal_Map[id].Order_ID = id;
    }


    function IsEEGInserted(uint Order_Number,string memory EEG)private view returns(bool){
        for (uint i ; i < Signal_Map[Order_Number].EEG_Signal_Hash.length ; i++){
            if(Tools.isstringEQAL(EEG, Signal_Map[Order_Number].EEG_Signal_Hash[i]))
                return(true);
        }
        return (false);
    }
    // User Send His/Her Signal For Determine Order Board / User Call This
    function TransferSignalandToken(uint Order_Number,address Scientist_Address,string memory EEG)public{
        require(! IsEEGInserted(Order_Number,EEG ), "EEG Is Dupplicated");
        Order storage myorder = Ord[Order_Number];
        require(balanceOf(myorder.Scientist_Address_Creator) >= myorder.Token_Pay ,"Scientist Dont Have Enough Token");
        require(myorder.Instance_Remains != 0, "Order Is Complete");
        // require(User_Map[User_ID].User_Address == msg.sender,"Sender Should Be User");
        require(OrderToOwner[Order_Number] == Scientist_Address,"Order Number is not Equal with Scientist_Address");
        // Recieve Biobit Against TX
        CalculateReward();
        // Token Exchanges
        _balances[myorder.Scientist_Address_Creator] = _balances[myorder.Scientist_Address_Creator].sub
        ((myorder.Token_Pay)/(myorder.Instance_Count));
        _balances[msg.sender] = _balances[msg.sender].add((myorder.Token_Pay)/(myorder.Instance_Count));
        Signal_Map[Order_Number].EEG_Signal_Hash.push(EEG);
        myorder.Instance_Remains--;

    }
    function GetUserSignal(uint Order_Number,uint _Scientist_ID)public view returns(string memory){
        Order storage myorder = Ord[Order_Number];
        require(ScientistID[msg.sender] == _Scientist_ID,"Wrong ID");
        require(myorder.Scientist_Address_Creator == msg.sender);
        string memory str = "";
        for (uint i ; i< Signal_Map[Order_Number].EEG_Signal_Hash.length ; i++){
            str = Tools.concatstring(str, Tools.uint2str(i));
            str = Tools.concatstring(str, " : Hash =>>  ");
            str = Tools.concatstring(str, Signal_Map[Order_Number].EEG_Signal_Hash[i]) ;
            str = Tools.concatstring(str , "  >> ");
            if( i != Signal_Map[Order_Number].EEG_Signal_Hash.length - 1){
                str =  Tools.concatstring(str , ",");
            }
        }
        return(str);

    }

}
