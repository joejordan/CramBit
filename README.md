# CramBit [![Open in Gitpod][gitpod-badge]][gitpod] [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gitpod]: https://gitpod.io/#https://github.com/joejordan/CramBit
[gitpod-badge]: https://img.shields.io/badge/Gitpod-Open%20in%20Gitpod-FFB45B?logo=gitpod
[gha]: https://github.com/joejordan/CramBit/actions
[gha-badge]: https://github.com/joejordan/CramBit/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

***A Solidity library designed to cram as many arbitrary values into as small a space as possible.***

This project is somewhat inspired by OpenZeppelin's [BitMaps](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol) solution, which allows a user to store up to 256 boolean values in a single `uint256` variable. 

I thought, *why just booleans?* and decided to cram multiple arbitrary values into the `bytes` container of your choice. It works by creating a list of packing instructions, i.e. an array of `PackBytes` structs, that tells the `pack` function

1. the value (in byte format) that you want to store, and 
2. the maximum number of bits that that value could contain.

Unpacking a packed variable just performs the reverse, using the packing instructions you already created to unpack your original values.

Why would you want to do something like this? Well, on-chain storage is pretty expensive, so if you can save space by fitting more information into a smaller container, it might be worth the effort.

### Example Use Case

One immediate use case came to mind when building this, that being the efficient storage of NFT attributes, especially characters or inventory for Web3 gaming. Characters in games can have dozens, perhaps even hundreds of attributes, with each attribute representing for example 1 of 100 hairstyles, a 32-bit hair color, 1 of 12 face types, etc.

Rather than store all that information on-chain in a complex struct that may take up multiple storage slots, the data could instead be fit into a single 256 bit value or smaller, depending on your data needs.

## Overview

### Foundry

First, run the install step:

```sh
forge install --no-commit joejordan/CramBit
```

Then, add this to your `remappings.txt` file:

```text
crambit=lib/CramBit/src/
```

### Node.js

```sh
yarn add crambit
# or
npm install crambit
```

## Getting Started

Import the library into your Solidity contract, i.e.

```solidity
import { CramBit } from "crambit/CramBit.sol";
```

Packing instructions can be created in several different ways. Ultimately, the `pack` function just needs an array of `PackBytes` structs so that it knows what values to pack and how much space to give each value. Here is one example that creates a PackBytes array and packs two values into a single `bytes1` variable:

```solidity
   CramBit.PackBytes1[] memory packInstructions = new CramBit.PackBytes1[](2);
   bytes1 value1 = 0x0f; // 4 bytes max (1111)
   bytes1 value2 = 0x0f; // 4 bytes max (1111)

   // define our packing instructions
   packInstructions[0] = CramBit.PackBytes1({ maxBits: 4, data: value1 });
   packInstructions[1] = CramBit.PackBytes1({ maxBits: 4, data: value2 });

   // pack our data into a bytes1 value
   bytes1 packedBytes1 = CramBit.pack(packInstructions);
```

Unpacking is pretty easy as well. CramBit has a helper function to convert your pack instructions into an unpack map, essentially an array of values that represent the maxBits for each packed value. Unpacking can be done like this:

```solidity
   // generate an unpack map from our packInstructions
   uint8[] memory unpackMap = CramBit.packToUnpackMap(packInstructions);

   // unpack our packed values
   uint8[] memory unpackedValues = CramBit.unpackBytes1(packedBytes1, unpackMap);

   // assert that unpacked values match the original values
   assertEq(unpackedValues[0], uint8(value1));
   assertEq(unpackedValues[1], uint8(value2));
```

Check out the [test directory](https://github.com/joejordan/CramBit/tree/main/test) for more examples.

**One important caveat** when creating your packing instructions array is that the total `maxBits` for all of your entries must add up to the same number of bits as the container it's going in, or you're going to get weird numbers back when unpacking.

For example, if you were packing a number of values into in a `bytes1` variable, the total number of `maxBits` for all entries must add up to 8. If you end up with some space at the end, just remember to add an extra entry of any remaining `maxBits` you need to fill the container. Here's an example:

```solidity
   CramBit.PackBytes1[] memory packInstructions = new CramBit.PackBytes1[](4);
   uint8 value1 = 7; // 3 bytes max (111)
   uint8 value2 = 2; // 2 bytes max (10)
   uint8 value3 = 1; // 1 bytes max (1)
   bytes1 UNUSED = 0;
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
```


## Contribute

Contributions are welcome! [Open](https://github.com/joejordan/CramBit/issues/new) an issue or submit a PR. There is always room for improvement. The instructions below will walk you through setting up for contributions.

### Pre-Requisites

You will need the following software on your machine:

- [Git](https://git-scm.com/downloads)
- [Foundry](https://github.com/foundry-rs/foundry)
- [Node.js](https://nodejs.org/en/download/)
- [Yarn](https://yarnpkg.com/)

### Set Up

Clone this repository:

```sh
$ git clone https://github.com/joejordan/CramBit.git
```

Then, inside the project's directory, run this to install dependencies:

```sh
$ yarn install
```

Your environment should now be ready for your improvements.

## Security

This code has not been professionally audited by any third parties. If you use this library and include it in a professional audit, please let me know via [Twitter Direct Message](https://twitter.com/JJordan) for inclusion in this documentation.

If you discover any security issues with the library, please report them via [Twitter Direct Message](https://twitter.com/JJordan).

### Disclaimer

This is experimental software and is provided on an "as is" basis. No expressed or implied warranties are granted of any kind. I will not be liable for any loss, direct or indirect, related to the use or misuse of this codebase.

## Acknowledgements

- To my loving and supportive wife who always has my back. ♥

## License

CramBit is released under the [MIT License](./LICENSE.md).
