pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "IERC20.sol";
import "ERC20s.sol";
contract TokenSpammer {
    struct message {
        bool completed;
        address receiver;
        string mess;
        uint pointer;
    }
    mapping (byte => address) public token;
    message[] public m;
    function createmessage(address rev, string calldata mess) public {
        m.push(message(false, rev, mess, 0));
    }
    function create(byte s) public {
        if(token[s] != address(0)) revert("already exists");
        string memory _a = _bytes32ToString(s);
        ERC20s _b = new ERC20s(_a, _a);
        token[s] = address(_b);
    }
    function _bytes32ToString(bytes32 x) private pure returns (string memory) {
    bytes memory bytesString = new bytes(32);
    uint charCount = 0;
    for (uint j = 0; j < 32; j++) {
        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
        }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (uint j = 0; j < charCount; j++) {
        bytesStringTrimmed[j] = bytesString[j];
    }
    return string(bytesStringTrimmed);
    }
    function listallmsg() public view returns (message[] memory) {
        return m;
    }
    function sendmsg(uint _m, uint _point) public {
        require(!m[_m].completed);
        for(uint i = 0; i < _point; i++) {
            byte char = bytes(m[_m].mess)[m[_m].pointer+i];
            if (char == byte(0)) {
                m[_m].completed = true;
                break;
            }
            else IERC20(token[char]).transfer(m[_m].receiver, 1 * 10 ** 18);
        }
        m[_m].pointer += _point;
        if(_point == bytes(m[_m].mess).length) m[_m].completed = true;
    }
}