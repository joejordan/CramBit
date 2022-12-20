// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import { console2 } from "forge-std/console2.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { CramBit } from "src/CramBit.sol";

/// @title CramBitBytes1Test
/// @author Joe Jordan
/// @notice Tests to verify CramBit functionality
contract CramBitBytes1Test is PRBTest, StdCheats {
    bytes1 internal constant UNUSED = 0;

    function setUp() public {
        // solhint-disable-previous-line no-empty-blocks
    }

    function testBytes1TwoValues() public {
        CramBit.PackBytes1[] memory packInstructions = new CramBit.PackBytes1[](2);
        bytes1 value1 = 0x0f; // 4 bytes max (1111)
        bytes1 value2 = 0x0f; // 4 bytes max (1111)
        // packed binary value: 1111_1111

        // define our packing instructions
        packInstructions[0] = CramBit.PackBytes1({ maxBits: 4, data: value1 });
        packInstructions[1] = CramBit.PackBytes1({ maxBits: 4, data: value2 });

        // pack our data into a bytes1 value
        bytes1 packedBytes1 = CramBit.pack(packInstructions);

        // assert that value was packed correctly
        assertEq(packedBytes1, bytes1(0xff));

        // generate an unpack map from our packInstructions
        uint8[] memory unpackMap = CramBit.packToUnpackMap(packInstructions);

        // unpack our packed values
        uint8[] memory unpackedValues = CramBit.unpackBytes1(packedBytes1, unpackMap);

        // assert that unpacked values match the original values
        assertEq(unpackedValues[0], uint8(value1));
        assertEq(unpackedValues[1], uint8(value2));
    }

    function testBytes1ThreeValues() public {
        CramBit.PackBytes1[] memory packInstructions = new CramBit.PackBytes1[](3);
        uint8 value1 = 7; // 3 bytes max (111)
        uint8 value2 = 6; // 3 bytes max (110)
        uint8 value3 = 3; // 2 bytes max (11)
        // packed binary value: 111_110_11

        // define our packing instructions
        packInstructions[0] = CramBit.PackBytes1({ maxBits: 3, data: bytes1(value1) });
        packInstructions[1] = CramBit.PackBytes1({ maxBits: 3, data: bytes1(value2) });
        packInstructions[2] = CramBit.PackBytes1({ maxBits: 2, data: bytes1(value3) });

        // pack our data into a bytes1 value
        bytes1 packedBytes1 = CramBit.pack(packInstructions);

        // assert that value was packed correctly (11111011 == 0xfb)
        assertEq(packedBytes1, bytes1(0xfb));

        // generate an unpack map from our packInstructions
        uint8[] memory unpackMap = CramBit.packToUnpackMap(packInstructions);

        // unpack our packed values
        uint8[] memory unpackedValues = CramBit.unpackBytes1(packedBytes1, unpackMap);

        // assert that unpacked values match the original values
        assertEq(unpackedValues[0], uint8(value1));
        assertEq(unpackedValues[1], uint8(value2));
        assertEq(unpackedValues[2], uint8(value3));
    }

    function testBytes1ThreeValuesWithSpace() public {
        CramBit.PackBytes1[] memory packInstructions = new CramBit.PackBytes1[](4);
        uint8 value1 = 7; // 3 bytes max (111)
        uint8 value2 = 2; // 2 bytes max (10)
        uint8 value3 = 1; // 1 bytes max (1)
        // packed binary value: 111_10_1_??

        // define our packing instructions
        packInstructions[0] = CramBit.PackBytes1({ maxBits: 3, data: bytes1(value1) });
        packInstructions[1] = CramBit.PackBytes1({ maxBits: 2, data: bytes1(value2) });
        packInstructions[2] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value3) });
        /// @dev important! when your other values require less than the max of the bytes container,
        /// you must include an UNUSED entry with the number of bytes remaining.
        packInstructions[3] = CramBit.PackBytes1({ maxBits: 2, data: UNUSED });

        // pack our data into a bytes1 value
        bytes1 packedBytes1 = CramBit.pack(packInstructions);

        // assert that value was packed correctly (111_10_1_00 == 0xF4)
        assertEq(packedBytes1, bytes1(0xF4));

        // generate an unpack map from our packInstructions
        uint8[] memory unpackMap = CramBit.packToUnpackMap(packInstructions);

        // unpack our packed values
        uint8[] memory unpackedValues = CramBit.unpackBytes1(packedBytes1, unpackMap);

        // for (uint256 i = 0; i < unpackedValues.length; i++) {
        //     console2.log("UNPACKED VALUE:", unpackedValues[i]);
        // }

        // assert that unpacked values match the original values
        assertEq(unpackedValues[0], value1);
        assertEq(unpackedValues[1], value2);
        assertEq(unpackedValues[2], value3);
    }

    function testBytes1EightValues() public {
        CramBit.PackBytes1[] memory packInstructions = new CramBit.PackBytes1[](8);
        uint8 value1 = 1; // 1 bytes max (1)
        uint8 value2 = 0; // 1 bytes max (0)
        uint8 value3 = 1; // 1 bytes max (1)
        uint8 value4 = 0; // 1 bytes max (0)
        uint8 value5 = 1; // 1 bytes max (1)
        uint8 value6 = 1; // 1 bytes max (1)
        uint8 value7 = 1; // 1 bytes max (1)
        uint8 value8 = 0; // 1 bytes max (0)
        // packed binary value: 10101110

        // define our packing instructions
        packInstructions[0] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value1) });
        packInstructions[1] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value2) });
        packInstructions[2] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value3) });
        packInstructions[3] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value4) });
        packInstructions[4] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value5) });
        packInstructions[5] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value6) });
        packInstructions[6] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value7) });
        packInstructions[7] = CramBit.PackBytes1({ maxBits: 1, data: bytes1(value8) });

        // pack our data into a bytes1 value
        bytes1 packedBytes1 = CramBit.pack(packInstructions);

        // assert that value was packed correctly (10101110 == 0xAE)
        assertEq(packedBytes1, bytes1(0xAE));

        // generate an unpack map from our packInstructions
        uint8[] memory unpackMap = CramBit.packToUnpackMap(packInstructions);

        // unpack our packed values
        uint8[] memory unpackedValues = CramBit.unpackBytes1(packedBytes1, unpackMap);

        // for (uint256 i = 0; i < unpackedValues.length; i++) {
        //     console2.log("UNPACKED VALUE:", unpackedValues[i]);
        // }

        // assert that unpacked values match the original values
        assertEq(unpackedValues[0], value1);
        assertEq(unpackedValues[1], value2);
        assertEq(unpackedValues[2], value3);
        assertEq(unpackedValues[3], value4);
        assertEq(unpackedValues[4], value5);
        assertEq(unpackedValues[5], value6);
        assertEq(unpackedValues[6], value7);
        assertEq(unpackedValues[7], value8);
    }
}
