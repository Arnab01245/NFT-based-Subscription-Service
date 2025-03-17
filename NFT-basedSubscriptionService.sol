// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract NFTSubscriptionService {

    // Structure to hold details of a subscription
    struct Subscription {
        uint256 subscriptionId;
        string title;
        string description;
        uint256 startDate;
        uint256 endDate;
        address subscriber;
        bool isActive;
    }

    uint256 public subscriptionCount;
    mapping(uint256 => Subscription) public subscriptions;

    // Event to be emitted when a new subscription is created
    event SubscriptionCreated(
        uint256 indexed subscriptionId,
        string title,
        string description,
        uint256 startDate,
        uint256 endDate,
        address indexed subscriber
    );

    // Function to create a new subscription
    function createSubscription(
        string memory _title,
        string memory _description,
        uint256 _startDate,
        uint256 _endDate
    ) public {
        require(_startDate < _endDate, "Start date must be before end date");

        subscriptionCount++;
        subscriptions[subscriptionCount] = Subscription({
            subscriptionId: subscriptionCount,
            title: _title,
            description: _description,
            startDate: _startDate,
            endDate: _endDate,
            subscriber: msg.sender,
            isActive: true
        });

        emit SubscriptionCreated(subscriptionCount, _title, _description, _startDate, _endDate, msg.sender);
    }

    // Function to check the status of a subscription
    function getSubscription(uint256 _subscriptionId) public view returns (
        string memory title,
        string memory description,
        uint256 startDate,
        uint256 endDate,
        address subscriber,
        bool isActive
    ) {
        Subscription storage subscription = subscriptions[_subscriptionId];
        return (
            subscription.title,
            subscription.description,
            subscription.startDate,
            subscription.endDate,
            subscription.subscriber,
            subscription.isActive
        );
    }

    // Function to deactivate a subscription (e.g., after a user cancels it)
    function deactivateSubscription(uint256 _subscriptionId) public {
        require(subscriptions[_subscriptionId].subscriber == msg.sender, "You are not the subscriber");
        require(subscriptions[_subscriptionId].isActive, "Subscription is already inactive");

        subscriptions[_subscriptionId].isActive = false;
    }
}
