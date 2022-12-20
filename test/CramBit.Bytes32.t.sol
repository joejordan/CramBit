// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import { console2 } from "forge-std/console2.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { CramBit } from "src/CramBit.sol";

/// @title CramBitBytes32Test
/// @author Joe Jordan
/// @notice Tests to verify CramBit functionality
contract CramBitBytes32Test is PRBTest, StdCheats {
    bytes32 internal constant UNUSED = 0;

    function setUp() public {
        // solhint-disable-previous-line no-empty-blocks
    }

    function testBytes32TwoValues() public {
        CramBit.PackBytes32[] memory packInstructions = new CramBit.PackBytes32[](2);

        bytes32 value1 = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff; // 16 bytes max
        bytes32 value2 = 0x00000000000000000000000000000000f1f2f3f4f5f6f7f8f9f0fafbfcfdfeff; // 16 bytes max
        // packed value: fffffffffffffffffffffffffffffffff1f2f3f4f5f6f7f8f9f0fafbfcfdfeff

        // define our packing instructions
        packInstructions[0] = CramBit.PackBytes32({ maxBits: 128, data: value1 });
        packInstructions[1] = CramBit.PackBytes32({ maxBits: 128, data: value2 });

        // pack our data into a bytes32 value
        bytes32 packedBytes32 = CramBit.pack(packInstructions);

        // assert that value was packed correctly
        assertEq(packedBytes32, bytes32(0xfffffffffffffffffffffffffffffffff1f2f3f4f5f6f7f8f9f0fafbfcfdfeff));

        // generate an unpack map from our packInstructions
        uint16[] memory unpackMap = CramBit.packToUnpackMap(packInstructions);

        // unpack our packed values
        uint256[] memory unpackedValues = CramBit.unpackBytes32(packedBytes32, unpackMap);

        // assert that unpacked values match the original values
        assertEq(unpackedValues[0], uint256(value1));
        assertEq(unpackedValues[1], uint256(value2));
    }

    function testBytes32ThreeValuesWithSpace() public {
        CramBit.PackBytes32[] memory packInstructions = new CramBit.PackBytes32[](4);

        uint256 value1 = 7; // 3 bytes max (111)
        uint256 value2 = 2; // 2 bytes max (10)
        uint256 value3 = 1; // 1 bytes max (1)

        // define our packing instructions
        packInstructions[0] = CramBit.PackBytes32({ maxBits: 3, data: bytes32(value1) });
        packInstructions[1] = CramBit.PackBytes32({ maxBits: 2, data: bytes32(value2) });
        packInstructions[2] = CramBit.PackBytes32({ maxBits: 1, data: bytes32(value3) });
        packInstructions[3] = CramBit.PackBytes32({ maxBits: 250, data: UNUSED });

        // pack our data into a bytes32 value
        bytes32 packedBytes32 = CramBit.pack(packInstructions);

        // console2.logBytes32(packedBytes32);

        // assert that value was packed correctly
        assertEq(packedBytes32, bytes32(0xf400000000000000000000000000000000000000000000000000000000000000));

        // generate an unpack map from our packInstructions
        uint16[] memory unpackMap = CramBit.packToUnpackMap(packInstructions);

        // unpack our packed values
        uint256[] memory unpackedValues = CramBit.unpackBytes32(packedBytes32, unpackMap);

        for (uint256 i = 0; i < unpackedValues.length; i++) {
            console2.log("UNPACKED VALUE:", unpackedValues[i]);
        }

        // assert that unpacked values match the original values
        assertEq(unpackedValues[0], uint256(value1));
        assertEq(unpackedValues[1], uint256(value2));
        assertEq(unpackedValues[2], uint256(value3));
    }
}
