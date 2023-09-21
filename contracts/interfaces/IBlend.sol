// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";
import "./IOfferController.sol";

interface IBlend is IOfferController {
    event LoanOfferTaken(
        bytes32 offerHash,
        uint256 lienId,
        address collection,
        address lender,
        address borrower,
        uint256 loanAmount,
        uint256 rate,
        uint256 tokenId,
        uint256 auctionDuration
    );

    event Repay(uint256 lienId, address collection);

    event StartAuction(uint256 lienId, address collection);

    event Refinance(
        uint256 lienId,
        address collection,
        address newLender,
        uint256 newAmount,
        uint256 newRate,
        uint256 newAuctionDuration
    );

    event Seize(uint256 lienId, address collection);

    event BuyLocked(
        uint256 lienId,
        address collection,
        address buyer,
        address seller,
        uint256 tokenId
    );

    function amountTaken(bytes32 offerHash) external view returns (uint256);

    function liens(uint256 lienId) external view returns (bytes32);

    /*//////////////////////////////////////////////////
                    BORROW FLOWS
    //////////////////////////////////////////////////*/
    function borrow(
        LoanOffer calldata offer,
        bytes calldata signature,
        uint256 loanAmount,
        uint256 collateralId
    ) external returns (uint256 lienId);

    function repay(Lien calldata lien, uint256 lienId) external;

    /*//////////////////////////////////////////////////
                    REFINANCING FLOWS
    //////////////////////////////////////////////////*/
    function startAuction(Lien calldata lien, uint256 lienId) external;

    function seize(LienPointer[] calldata lienPointers) external;

    function refinance(
        Lien calldata lien,
        uint256 lienId,
        LoanOffer calldata offer,
        bytes calldata signature
    ) external;

    function refinanceAuction(Lien calldata lien, uint256 lienId, uint256 rate) external;

    function refinanceAuctionByOther(
        Lien calldata lien,
        uint256 lienId,
        LoanOffer calldata offer,
        bytes calldata signature
    ) external;

    function borrowerRefinance(
        Lien calldata lien,
        uint256 lienId,
        uint256 loanAmount,
        LoanOffer calldata offer,
        bytes calldata signature
    ) external;

    /*//////////////////////////////////////////////////
                    MARKETPLACE FLOWS
    //////////////////////////////////////////////////*/

    // Purchase an NFT and use as collateral for a loan
    function buyToBorrow(
        LoanOffer calldata offer,
        bytes calldata signature,
        uint256 loanAmount,
        ExecutionV1 calldata execution
    ) external returns (uint256 lienId);

    // buyToBorrow wrapper that deposits ETH to pool
    function buyToBorrowETH(
        LoanOffer calldata offer,
        bytes calldata signature,
        uint256 loanAmount,
        ExecutionV1 calldata execution
    ) external payable returns (uint256 lienId);

    //Purchase a locked NFT; repay the initial loan; lock the token as collateral for a new loan
    function buyToBorrowLocked(
        Lien calldata lien,
        SellInput calldata sellInput,
        LoanInput calldata loanInput,
        uint256 loanAmount
    ) external returns (uint256 lienId);

    // buyToBorrowLocked wrapper that deposits ETH to pool
    function buyToBorrowLockedETH(    
        Lien calldata lien,
        SellInput calldata sellInput,
        LoanInput calldata loanInput,
        uint256 loanAmount
    ) external payable returns (uint256 lienId);

    // Purchases a locked NFT and uses the funds to repay the loan
    function buyLocked(
        Lien calldata lien,
        SellOffer calldata offer,
        bytes calldata signature
    ) external;

    // buyLocked wrapper that deposits ETH to pool
    function buyLockedETH(
        Lien calldata lien,
        SellOffer calldata offer,
        bytes calldata signature
    ) external payable;
    
    // Takes a bid on a locked NFT and use the funds to repay the lien
    function takeBid(Lien calldata lien, uint256 lienId, ExecutionV1 calldata execution) external;
}