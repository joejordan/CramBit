// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title CramBit
 * @author Joe Jordan
 * @notice A Solidity library designed to cram as many arbitrary values into as small a space as possible.
 */
library CramBit {
    /// @notice we use constants for clarity and DRY purposes
    uint8 internal constant BYTE1_BITS = 8;
    uint8 internal constant BYTE2_BITS = 16;
    uint8 internal constant BYTE4_BITS = 32;
    uint8 internal constant BYTE8_BITS = 64;
    uint8 internal constant BYTE9_BITS = 72;
    uint8 internal constant BYTE16_BITS = 128;
    uint16 internal constant BYTE32_BITS = 256;

    /// @notice these structs are used to provide directions
    /// to the pack() functions on how to pack our desired data.
    struct PackBytes1 {
        uint8 maxBits;
        bytes1 data;
    }

    struct PackBytes2 {
        uint8 maxBits;
        bytes2 data;
    }

    struct PackBytes4 {
        uint8 maxBits;
        bytes4 data;
    }

    struct PackBytes8 {
        uint8 maxBits;
        bytes8 data;
    }

    struct PackBytes9 {
        uint8 maxBits;
        bytes9 data;
    }

    struct PackBytes16 {
        uint8 maxBits;
        bytes16 data;
    }

    struct PackBytes32 {
        uint8 maxBits;
        bytes32 data;
    }

    /////////////////////////////////////////////////
    // External Bytes1 functions
    /////////////////////////////////////////////////

    /// @notice Pack 1 Byte with multiple values
    /// @dev warning: this has no checks to see if data value fits within maxBits. Proceed with care.
    function pack(PackBytes1[] memory packValues) external pure returns (bytes1) {
        bytes1 _packedData;
        uint8 _totalBits;
        uint8 _maxBits;

        for (uint8 i = 0; i < packValues.length; i++) {
            // extract the maxBits for the current value to be packed
            _maxBits = packValues[i].maxBits;
            // track the totalBits
            _totalBits += _maxBits;

            // bit count sanity check--prevents overflow error if totalBits is > BYTE1_BITS
            require(_totalBits <= BYTE1_BITS, "MAX_BITS_EXCEEDED");

            // take the current packValues entry and leftShift as far as we can go and still fit the value.
            // then OR the existing _packedData to include what has already been packed.
            _packedData = bitLeftShift1(bytes1(packValues[i].data), uint8(BYTE1_BITS - _totalBits)) | _packedData;
        }

        return _packedData;
    }

    /// @notice Unpack a packed bytes1 as outlined by the unpackMap
    function unpackBytes1(bytes1 packedData, uint8[] memory unpackMap) external pure returns (uint8[] memory) {
        // size the return array to match the number of bitSize entries
        uint8[] memory unpackedValues = new uint8[](unpackMap.length);
        uint8 _totalBits;
        uint8 _unpackSize;

        // We unpack our values in the reverse of how we packed them,
        // so we start with the last value that was packed into packedData.
        for (uint8 i = uint8(unpackMap.length); i > 0; i--) {
            // extract the number of bits to unpack in this iteration from the unpackMap
            _unpackSize = unpackMap[i - 1];

            // First, take the packedData and rightShift the total number of bits we've already unpacked.
            // Next, extract the last N bits (i.e. the next _unpackSize) to retrieve our next packed value.
            bytes1 unpackedByteValue = getLastNBits1(bitRightShift1(packedData, _totalBits), _unpackSize);

            // convert extracted byteValue to uint and store in array for return
            unpackedValues[i - 1] = uint8(unpackedByteValue);

            /*
             * We append _totalBits AFTER the byteValue extraction because we start at the right-most value
             * at position 0. Appending the unpackSize here tells the next iteration to skip (i.e. rightShift)
             * that many bits in packedData before extracting the next unpackSize via getLastNBits.
             */
            _totalBits += _unpackSize;
        }

        return unpackedValues;
    }

    /////////////////////////////////////////////////
    // External Bytes2 functions
    /////////////////////////////////////////////////

    /// @notice Pack 2 Bytes with multiple values
    /// @dev warning: this has no checks to see if data value fits within maxBits. Proceed with care.
    function pack(PackBytes2[] memory packValues) external pure returns (bytes2) {
        bytes2 _packedData;
        uint8 _totalBits;
        uint8 _maxBits;

        for (uint8 i = 0; i < packValues.length; i++) {
            // extract the maxBits for the current value to be packed
            _maxBits = packValues[i].maxBits;
            // track the totalBits
            _totalBits += _maxBits;

            // bit count sanity check--prevents overflow error if totalBits is > BYTE2_BITS
            require(_totalBits <= BYTE2_BITS, "MAX_BITS_EXCEEDED");

            // take the current packValues entry and leftShift as far as we can go and still fit the value.
            // then OR the existing _packedData to include what has already been packed.
            _packedData = bitLeftShift2(bytes2(packValues[i].data), uint8(BYTE2_BITS - _totalBits)) | _packedData;
        }

        return _packedData;
    }

    /// @notice Unpack a packed bytes2 as outlined by the unpackMap
    function unpackBytes2(bytes2 packedData, uint8[] memory unpackMap) external pure returns (uint16[] memory) {
        // size the return array to match the number of bitSize entries
        uint16[] memory unpackedValues = new uint16[](unpackMap.length);
        uint8 _totalBits;
        uint8 _unpackSize;

        // We unpack our values in the reverse of how we packed them,
        // so we start with the last value that was packed into packedData.
        for (uint8 i = uint8(unpackMap.length); i > 0; i--) {
            // extract the number of bits to unpack in this iteration from the unpackMap
            _unpackSize = unpackMap[i - 1];

            // First, take the packedData and rightShift the total number of bits we've already unpacked.
            // Next, extract the last N bits (i.e. the next _unpackSize) to retrieve our next packed value.
            bytes2 unpackedByteValue = getLastNBits2(bitRightShift2(packedData, _totalBits), _unpackSize);

            // convert extracted byteValue to uint and store in array for return
            unpackedValues[i - 1] = uint16(unpackedByteValue);

            /*
             * We append _totalBits AFTER the byteValue extraction because we start at the right-most value
             * at position 0. Appending the unpackSize here tells the next iteration to skip (i.e. rightShift)
             * that many bits in packedData before extracting the next unpackSize via getLastNBits.
             */
            _totalBits += _unpackSize;
        }

        return unpackedValues;
    }

    /////////////////////////////////////////////////
    // External Bytes4 functions
    /////////////////////////////////////////////////

    /// @notice Pack 4 Bytes with multiple values
    /// @dev warning: this has no checks to see if data value fits within maxBits. Proceed with care.
    function pack(PackBytes4[] memory packValues) external pure returns (bytes4) {
        bytes4 _packedData;
        uint8 _totalBits;
        uint8 _maxBits;

        for (uint8 i = 0; i < packValues.length; i++) {
            // extract the maxBits for the current value to be packed
            _maxBits = packValues[i].maxBits;
            // track the totalBits
            _totalBits += _maxBits;

            // bit count sanity check--prevents overflow error if totalBits is > BYTE4_BITS
            require(_totalBits <= BYTE4_BITS, "MAX_BITS_EXCEEDED");

            // take the current packValues entry and leftShift as far as we can go and still fit the value.
            // then OR the existing _packedData to include what has already been packed.
            _packedData = bitLeftShift4(bytes4(packValues[i].data), uint8(BYTE4_BITS - _totalBits)) | _packedData;
        }

        return _packedData;
    }

    /// @notice Unpack a packed bytes4 as outlined by the unpackMap
    function unpackBytes4(bytes4 packedData, uint8[] memory unpackMap) external pure returns (uint32[] memory) {
        // size the return array to match the number of bitSize entries
        uint32[] memory unpackedValues = new uint32[](unpackMap.length);
        uint8 _totalBits;
        uint8 _unpackSize;

        // We unpack our values in the reverse of how we packed them,
        // so we start with the last value that was packed into packedData.
        for (uint8 i = uint8(unpackMap.length); i > 0; i--) {
            // extract the number of bits to unpack in this iteration from the unpackMap
            _unpackSize = unpackMap[i - 1];

            // First, take the packedData and rightShift the total number of bits we've already unpacked.
            // Next, extract the last N bits (i.e. the next _unpackSize) to retrieve our next packed value.
            bytes4 unpackedByteValue = getLastNBits4(bitRightShift4(packedData, _totalBits), _unpackSize);

            // convert extracted byteValue to uint and store in array for return
            unpackedValues[i - 1] = uint32(unpackedByteValue);

            /*
             * We append _totalBits AFTER the byteValue extraction because we start at the right-most value
             * at position 0. Appending the unpackSize here tells the next iteration to skip (i.e. rightShift)
             * that many bits in packedData before extracting the next unpackSize via getLastNBits.
             */
            _totalBits += _unpackSize;
        }

        return unpackedValues;
    }

    /////////////////////////////////////////////////
    // External Bytes8 functions
    /////////////////////////////////////////////////

    /// @notice Pack 8 Bytes with multiple values
    /// @dev warning: this has no checks to see if data value fits within maxBits. Proceed with care.
    function pack(PackBytes8[] memory packValues) external pure returns (bytes8) {
        bytes8 _packedData;
        uint8 _totalBits;
        uint8 _maxBits;

        for (uint8 i = 0; i < packValues.length; i++) {
            // extract the maxBits for the current value to be packed
            _maxBits = packValues[i].maxBits;
            // track the totalBits
            _totalBits += _maxBits;

            // bit count sanity check--prevents overflow error if totalBits is > BYTE8_BITS
            require(_totalBits <= BYTE8_BITS, "MAX_BITS_EXCEEDED");

            // take the current packValues entry and leftShift as far as we can go and still fit the value.
            // then OR the existing _packedData to include what has already been packed.
            _packedData = bitLeftShift8(bytes8(packValues[i].data), uint8(BYTE8_BITS - _totalBits)) | _packedData;
        }

        return _packedData;
    }

    /// @notice Unpack a packed bytes8 as outlined by the unpackMap
    function unpackBytes8(bytes8 packedData, uint8[] memory unpackMap) external pure returns (uint64[] memory) {
        // size the return array to match the number of bitSize entries
        uint64[] memory unpackedValues = new uint64[](unpackMap.length);
        uint8 _totalBits;
        uint8 _unpackSize;

        // We unpack our values in the reverse of how we packed them,
        // so we start with the last value that was packed into packedData.
        for (uint8 i = uint8(unpackMap.length); i > 0; i--) {
            // extract the number of bits to unpack in this iteration from the unpackMap
            _unpackSize = unpackMap[i - 1];

            // First, take the packedData and rightShift the total number of bits we've already unpacked.
            // Next, extract the last N bits (i.e. the next _unpackSize) to retrieve our next packed value.
            bytes8 unpackedByteValue = getLastNBits8(bitRightShift8(packedData, _totalBits), _unpackSize);

            // convert extracted byteValue to uint and store in array for return
            unpackedValues[i - 1] = uint64(unpackedByteValue);

            /*
             * We append _totalBits AFTER the byteValue extraction because we start at the right-most value
             * at position 0. Appending the unpackSize here tells the next iteration to skip (i.e. rightShift)
             * that many bits in packedData before extracting the next unpackSize via getLastNBits.
             */
            _totalBits += _unpackSize;
        }

        return unpackedValues;
    }

    /////////////////////////////////////////////////
    // External Bytes9 functions
    /////////////////////////////////////////////////

    /// @notice Pack 9 Bytes with multiple values
    /// @dev warning: this has no checks to see if data value fits within maxBits. Proceed with care.
    function pack(PackBytes9[] memory packValues) external pure returns (bytes9) {
        bytes9 _packedData;
        uint8 _totalBits;
        uint8 _maxBits;

        for (uint8 i = 0; i < packValues.length; i++) {
            // extract the maxBits for the current value to be packed
            _maxBits = packValues[i].maxBits;
            // track the totalBits
            _totalBits += _maxBits;

            // bit count sanity check--prevents overflow error if totalBits is > BYTE9_BITS
            require(_totalBits <= BYTE9_BITS, "MAX_BITS_EXCEEDED");

            // take the current packValues entry and leftShift as far as we can go and still fit the value.
            // then OR the existing _packedData to include what has already been packed.
            _packedData = bitLeftShift9(bytes9(packValues[i].data), uint8(BYTE9_BITS - _totalBits)) | _packedData;
        }

        return _packedData;
    }

    /// @notice Unpack a packed bytes9 as outlined by the unpackMap
    function unpackBytes9(bytes9 packedData, uint8[] memory unpackMap) external pure returns (uint72[] memory) {
        // size the return array to match the number of bitSize entries
        uint72[] memory unpackedValues = new uint72[](unpackMap.length);
        uint8 _totalBits;
        uint8 _unpackSize;

        // We unpack our values in the reverse of how we packed them,
        // so we start with the last value that was packed into packedData.
        for (uint8 i = uint8(unpackMap.length); i > 0; i--) {
            // extract the number of bits to unpack in this iteration from the unpackMap
            _unpackSize = unpackMap[i - 1];

            // First, take the packedData and rightShift the total number of bits we've already unpacked.
            // Next, extract the last N bits (i.e. the next _unpackSize) to retrieve our next packed value.
            bytes9 unpackedByteValue = getLastNBits9(bitRightShift9(packedData, _totalBits), _unpackSize);

            // convert extracted byteValue to uint and store in array for return
            unpackedValues[i - 1] = uint72(unpackedByteValue);

            /*
             * We append _totalBits AFTER the byteValue extraction because we start at the right-most value
             * at position 0. Appending the unpackSize here tells the next iteration to skip (i.e. rightShift)
             * that many bits in packedData before extracting the next unpackSize via getLastNBits.
             */
            _totalBits += _unpackSize;
        }

        return unpackedValues;
    }

    /////////////////////////////////////////////////
    // External Bytes16 functions
    /////////////////////////////////////////////////

    /// @notice Pack 16 Bytes with multiple values
    /// @dev warning: this has no checks to see if data value fits within maxBits. Proceed with care.
    function pack(PackBytes16[] memory packValues) external pure returns (bytes16) {
        bytes16 _packedData;
        uint8 _totalBits;
        uint8 _maxBits;

        for (uint8 i = 0; i < packValues.length; i++) {
            // extract the maxBits for the current value to be packed
            _maxBits = packValues[i].maxBits;
            // track the totalBits
            _totalBits += _maxBits;

            // bit count sanity check--prevents overflow error if totalBits is > BYTE16_BITS
            require(_totalBits <= BYTE16_BITS, "MAX_BITS_EXCEEDED");

            // take the current packValues entry and leftShift as far as we can go and still fit the value.
            // then OR the existing _packedData to include what has already been packed.
            _packedData = bitLeftShift16(bytes16(packValues[i].data), uint8(BYTE16_BITS - _totalBits)) | _packedData;
        }

        return _packedData;
    }

    /// @notice Unpack a packed bytes16 as outlined by the unpackMap
    function unpackBytes16(bytes16 packedData, uint8[] memory unpackMap) external pure returns (uint128[] memory) {
        // size the return array to match the number of bitSize entries
        uint128[] memory unpackedValues = new uint128[](unpackMap.length);
        uint8 _totalBits;
        uint8 _unpackSize;

        // We unpack our values in the reverse of how we packed them,
        // so we start with the last value that was packed into packedData.
        for (uint8 i = uint8(unpackMap.length); i > 0; i--) {
            // extract the number of bits to unpack in this iteration from the unpackMap
            _unpackSize = unpackMap[i - 1];

            // First, take the packedData and rightShift the total number of bits we've already unpacked.
            // Next, extract the last N bits (i.e. the next _unpackSize) to retrieve our next packed value.
            bytes16 unpackedByteValue = getLastNBits16(bitRightShift16(packedData, _totalBits), _unpackSize);

            // convert extracted byteValue to uint and store in array for return
            unpackedValues[i - 1] = uint128(unpackedByteValue);

            /*
             * We append _totalBits AFTER the byteValue extraction because we start at the right-most value
             * at position 0. Appending the unpackSize here tells the next iteration to skip (i.e. rightShift)
             * that many bits in packedData before extracting the next unpackSize via getLastNBits.
             */
            _totalBits += _unpackSize;
        }

        return unpackedValues;
    }

    /////////////////////////////////////////////////
    // External Bytes32 functions
    /////////////////////////////////////////////////

    /// @dev warning: this has no checks to see if data value fits within maxBits. Proceed with care.
    function pack(PackBytes32[] memory packValues) external pure returns (bytes32) {
        bytes32 _packedData;
        uint16 _totalBits;
        uint16 _maxBits;

        for (uint16 i = 0; i < packValues.length; i++) {
            // extract the maxBits for the current value to be packed
            _maxBits = packValues[i].maxBits;
            // track the totalBits
            _totalBits += _maxBits;

            // bit count sanity check--prevents overflow error if totalBits is > BYTE32_BITS
            require(_totalBits <= BYTE32_BITS, "MAX_BITS_EXCEEDED");

            // take the current packValues entry and leftShift as far as we can go and still fit the value.
            // then OR the existing _packedData to include what has already been packed.
            _packedData = bitLeftShift32(bytes32(packValues[i].data), uint16(BYTE32_BITS - _totalBits)) | _packedData;
        }

        return _packedData;
    }

    /// @notice Unpack a packed bytes32 as outlined by the unpackMap
    function unpackBytes32(bytes32 packedData, uint16[] memory unpackMap) external pure returns (uint256[] memory) {
        // size the return array to match the number of bitSize entries
        uint256[] memory unpackedValues = new uint256[](unpackMap.length);
        uint16 _totalBits;
        uint16 _unpackSize;

        // We unpack our values in the reverse of how we packed them,
        // so we start with the last value that was packed into packedData.
        for (uint16 i = uint16(unpackMap.length); i > 0; i--) {
            // extract the number of bits to unpack in this iteration from the unpackMap
            _unpackSize = unpackMap[i - 1];

            // First, take the packedData and rightShift the total number of bits we've already unpacked.
            // Next, extract the last N bits (i.e. the next _unpackSize) to retrieve our next packed value.
            bytes32 unpackedByteValue = getLastNBits32(bitRightShift32(packedData, _totalBits), _unpackSize);

            // convert extracted byteValue to uint and store in array for return
            unpackedValues[i - 1] = uint256(unpackedByteValue);

            /*
             * We append _totalBits AFTER the byteValue extraction because we start at the right-most value
             * at position 0. Appending the unpackSize here tells the next iteration to skip (i.e. rightShift)
             * that many bits in packedData before extracting the next unpackSize via getLastNBits.
             */
            _totalBits += _unpackSize;
        }

        return unpackedValues;
    }

    /* *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- //
    // *-*-*-*-*-*-*-*-*-*-*-*- HELPER FUNCTIONS *-*-*-*-*-*-*-*-*-*-*-*- //
    // *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- */

    /// @notice helper function to convert a packValues list into an unpacking map for the unpack function.
    function packToUnpackMap(PackBytes1[] memory packValues) external pure returns (uint8[] memory) {
        // size the return array to match the number of packed value entries
        uint8[] memory unpackMap = new uint8[](packValues.length);

        for (uint8 i = 0; i < uint8(packValues.length); i++) {
            unpackMap[i] = packValues[i].maxBits;
        }

        return unpackMap;
    }

    /// @notice helper function to convert a packValues list into an unpacking map for the unpack function.
    function packToUnpackMap(PackBytes2[] memory packValues) external pure returns (uint8[] memory) {
        // size the return array to match the number of packed value entries
        uint8[] memory unpackMap = new uint8[](packValues.length);

        for (uint8 i = 0; i < uint8(packValues.length); i++) {
            unpackMap[i] = packValues[i].maxBits;
        }

        return unpackMap;
    }

    /// @notice helper function to convert a packValues list into an unpacking map for the unpack function.
    function packToUnpackMap(PackBytes4[] memory packValues) external pure returns (uint8[] memory) {
        // size the return array to match the number of packed value entries
        uint8[] memory unpackMap = new uint8[](packValues.length);

        for (uint8 i = 0; i < uint8(packValues.length); i++) {
            unpackMap[i] = packValues[i].maxBits;
        }

        return unpackMap;
    }

    /// @notice helper function to convert a packValues list into an unpacking map for the unpack function.
    function packToUnpackMap(PackBytes8[] memory packValues) external pure returns (uint8[] memory) {
        // size the return array to match the number of packed value entries
        uint8[] memory unpackMap = new uint8[](packValues.length);

        for (uint8 i = 0; i < uint8(packValues.length); i++) {
            unpackMap[i] = packValues[i].maxBits;
        }

        return unpackMap;
    }

    /// @notice helper function to convert a packValues list into an unpacking map for the unpack function.
    function packToUnpackMap(PackBytes9[] memory packValues) external pure returns (uint8[] memory) {
        // size the return array to match the number of packed value entries
        uint8[] memory unpackMap = new uint8[](packValues.length);

        for (uint8 i = 0; i < uint8(packValues.length); i++) {
            unpackMap[i] = packValues[i].maxBits;
        }

        return unpackMap;
    }

    /// @notice helper function to convert a packValues list into an unpacking map for the unpack function.
    function packToUnpackMap(PackBytes16[] memory packValues) external pure returns (uint8[] memory) {
        // size the return array to match the number of packed value entries
        uint8[] memory unpackMap = new uint8[](packValues.length);

        for (uint8 i = 0; i < uint8(packValues.length); i++) {
            unpackMap[i] = packValues[i].maxBits;
        }

        return unpackMap;
    }

    /// @notice helper function to convert a packValues list into an unpacking map for the unpack function.
    function packToUnpackMap(PackBytes32[] memory packValues) external pure returns (uint16[] memory) {
        // size the return array to match the number of packed value entries
        uint16[] memory unpackMap = new uint16[](packValues.length);

        for (uint16 i = 0; i < uint16(packValues.length); i++) {
            unpackMap[i] = packValues[i].maxBits;
        }

        return unpackMap;
    }

    // *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- //
    // *-*-*-*-*-*-*-*-*-*-*-*- BIT SHIFT FUNCTIONS  *-*-*-*-*-*-*-*-*-*- //
    // *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- //

    // ================================
    //       bytes1 bit functions
    // ================================

    function bitLeftShift1(bytes1 value, uint8 shiftNBits) internal pure returns (bytes1) {
        return value << shiftNBits;
    }

    function bitRightShift1(bytes1 value, uint8 shiftNBits) internal pure returns (bytes1) {
        return value >> shiftNBits;
    }

    function getLastNBits1(bytes1 value, uint8 lastNBits) internal pure returns (bytes1) {
        uint8 valueUint = uint8(value);

        uint256 mask = (1 << lastNBits) - 1;

        uint8 lastNBitsUint = valueUint & uint8(mask);

        return bytes1(lastNBitsUint);
    }

    // ================================
    //       bytes2 bit functions
    // ================================

    function bitLeftShift2(bytes2 value, uint8 shiftNBits) internal pure returns (bytes2) {
        return value << shiftNBits;
    }

    function bitRightShift2(bytes2 value, uint8 shiftNBits) internal pure returns (bytes2) {
        return value >> shiftNBits;
    }

    function getLastNBits2(bytes2 value, uint8 lastNBits) internal pure returns (bytes2) {
        uint16 valueUint = uint16(value);

        uint256 mask = (1 << lastNBits) - 1;

        uint16 lastNBitsUint = valueUint & uint16(mask);

        return bytes2(lastNBitsUint);
    }

    // ================================
    //       bytes4 bit functions
    // ================================

    function bitLeftShift4(bytes4 value, uint8 shiftNBits) internal pure returns (bytes4) {
        return value << shiftNBits;
    }

    function bitRightShift4(bytes4 value, uint8 shiftNBits) internal pure returns (bytes4) {
        return value >> shiftNBits;
    }

    function getLastNBits4(bytes4 value, uint8 lastNBits) internal pure returns (bytes4) {
        uint32 valueUint = uint32(value);

        uint256 mask = (1 << lastNBits) - 1;

        uint32 lastNBitsUint = valueUint & uint32(mask);

        return bytes4(lastNBitsUint);
    }

    // ================================
    //       bytes8 bit functions
    // ================================

    function bitLeftShift8(bytes8 value, uint8 shiftNBits) internal pure returns (bytes8) {
        return value << shiftNBits;
    }

    function bitRightShift8(bytes8 value, uint8 shiftNBits) internal pure returns (bytes8) {
        return value >> shiftNBits;
    }

    function getLastNBits8(bytes8 value, uint8 lastNBits) internal pure returns (bytes8) {
        uint64 valueUint = uint64(value);

        uint256 mask = (1 << lastNBits) - 1;

        uint64 lastNBitsUint = valueUint & uint64(mask);

        return bytes8(lastNBitsUint);
    }

    // ================================
    //       bytes9 bit functions
    // ================================

    function bitLeftShift9(bytes9 value, uint8 shiftNBits) internal pure returns (bytes9) {
        return value << shiftNBits;
    }

    function bitRightShift9(bytes9 value, uint8 shiftNBits) internal pure returns (bytes9) {
        return value >> shiftNBits;
    }

    function getLastNBits9(bytes9 value, uint8 lastNBits) internal pure returns (bytes9) {
        uint72 valueUint = uint72(value);

        uint256 mask = (1 << lastNBits) - 1;

        uint72 lastNBitsUint = valueUint & uint72(mask);

        return bytes9(lastNBitsUint);
    }

    // ================================
    //       bytes16 bit functions
    // ================================

    function bitLeftShift16(bytes16 value, uint8 shiftNBits) internal pure returns (bytes16) {
        return value << shiftNBits;
    }

    function bitRightShift16(bytes16 value, uint8 shiftNBits) internal pure returns (bytes16) {
        return value >> shiftNBits;
    }

    function getLastNBits16(bytes16 value, uint8 lastNBits) internal pure returns (bytes16) {
        uint128 valueUint = uint128(value);

        uint256 mask = (1 << lastNBits) - 1;

        uint128 lastNBitsUint = valueUint & uint128(mask);

        return bytes16(lastNBitsUint);
    }

    // ================================
    //       bytes32 bit functions
    // ================================

    function bitLeftShift32(bytes32 value, uint16 shiftNBits) internal pure returns (bytes32) {
        return value << shiftNBits;
    }

    function bitRightShift32(bytes32 value, uint16 shiftNBits) internal pure returns (bytes32) {
        return value >> shiftNBits;
    }

    function getLastNBits32(bytes32 value, uint16 lastNBits) internal pure returns (bytes32) {
        uint256 valueUint = uint256(value);

        uint256 mask = (1 << lastNBits) - 1;

        uint256 lastNBitsUint = valueUint & uint256(mask);

        return bytes32(lastNBitsUint);
    }
}
