# Dynamic Customer ID Implementation Guide

## Overview
This document outlines the changes made to implement dynamic customer ID handling throughout the app, replacing hardcoded customer IDs with user-specific values.

## Problem Identified
The app was using hardcoded customer IDs (38590, 38595) in multiple screens:
- My Orders Screen: `customerId = 38590`
- Cart Screen: `"customerId": 38590` in checkout API
- Feedback Screen: `widget.customerId ?? 38590`
- Invoice Screen: `customerId: 38595` from dashboard navigation
- Dashboard Screen: Hardcoded navigation to invoice screen

## Solution Implemented

### 1. Updated User Model
**File**: `lib/features/auth/models/user.dart`
- Added `customerId` field to User class
- Updated constructor, fromJson, and toJson methods
- Added support for multiple possible field names in API response

### 2. Updated Dealer Model
**File**: `lib/features/auth/dealer/models/dealer.dart`
- Added `customerId` field to Dealer class
- Updated all related methods (constructor, fromJson, toJson, copyWith, props)
- Added support for multiple possible field names in API response

### 3. Created UserService
**File**: `lib/services/user_service.dart`
- Centralized user data access
- `getCurrentCustomerId()` - Gets current user's customer ID
- `getCurrentCustomerIdWithFallback()` - Gets customer ID with fallback value
- Helper methods for user information

### 4. Updated Dependency Injection
**File**: `lib/core/di/injection.dart`
- Added UserService to dependency injection
- Added helper getter for easy access

### 5. Updated All Screens

#### My Orders Screen
**File**: `lib/features/Dashboard/Dealer/Cards/My_Orders/screens/my_orders_screen.dart`
- Removed hardcoded `customerId = 38590`
- Added UserService dependency
- Dynamic customer ID loading in `_loadOrders()`
- Updated all BLoC events to use dynamic customer ID

#### Cart Screen
**File**: `lib/features/Dashboard/Dealer/Cards/Place_Order/Screen/cart_screen.dart`
- Added UserService dependency
- Dynamic customer ID in checkout API call
- Replaced hardcoded `"customerId": 38590`

#### Feedback Screen
**File**: `lib/features/Dashboard/Dealer/Cards/Feedback/screens/feedback_screen.dart`
- Added UserService dependency
- Dynamic customer ID in feedback submission
- Fallback to provided customerId or dynamic value

#### Dashboard Screen
**File**: `lib/features/Dashboard/Dealer/Screens/dashboard_dealer_screen.dart`
- Added UserService dependency
- Dynamic customer ID when navigating to invoice screen
- Async navigation method

## API Response Requirements

For the dynamic customer ID to work properly, the login API response should include the customer ID. Here are the expected formats:

### Option 1: In User Object
```json
{
  "success": true,
  "data": {
    "token": "your_jwt_token",
    "user": {
      "id": "user_id",
      "name": "User Name",
      "email": "user@example.com",
      "mobile_number": "9021345655",
      "customer_id": 12345,  // ← Customer ID here
      "user_type": "dealer"
    }
  }
}
```

### Option 2: In Data Object
```json
{
  "success": true,
  "data": {
    "token": "your_jwt_token",
    "customerId": 12345,  // ← Customer ID here
    "user": {
      "id": "user_id",
      "name": "User Name",
      "email": "user@example.com",
      "mobile_number": "9021345655",
      "user_type": "dealer"
    }
  }
}
```

### Option 3: In Dealer Object
```json
{
  "success": true,
  "data": {
    "token": "your_jwt_token",
    "data": {
      "name": "Dealer Name",
      "email": "dealer@example.com",
      "mobile": "9021345655",
      "customerId": 12345  // ← Customer ID here
    }
  }
}
```

## Usage Examples

### Getting Current Customer ID
```dart
// Get customer ID with fallback
final userService = getIt<UserService>();
final customerId = await userService.getCurrentCustomerIdWithFallback();

// Get customer ID (may return null)
final customerId = await userService.getCurrentCustomerId();
```

### Using in API Calls
```dart
// In any screen or service
final customerId = await getIt<UserService>().getCurrentCustomerIdWithFallback();

// Use in API call
final response = await apiService.post(
  '/api/orders',
  data: {
    'customerId': customerId,
    // other data...
  },
);
```

## Testing Different Users

With this implementation, when different users log in:

### User 1: Mobile "9021345655", Password "Anu@1234"
- Will get their specific customer ID from login response
- All API calls will use their customer ID

### User 2: Mobile "9995034500", Password "achu123"  
- Will get their specific customer ID from login response
- All API calls will use their customer ID

## Fallback Mechanism

If the API doesn't provide a customer ID or the user is not logged in:
- The system falls back to `38590` (configurable)
- This ensures the app continues to work during development/testing

## Benefits

1. **User-Specific Data**: Each user sees only their own orders, invoices, etc.
2. **Security**: No hardcoded IDs that could expose other users' data
3. **Scalability**: Easy to add new users without code changes
4. **Maintainability**: Centralized customer ID management
5. **Flexibility**: Configurable fallback values for development

## Next Steps

1. **Update API**: Ensure login endpoints return customer ID
2. **Test**: Verify with different user accounts
3. **Remove Fallbacks**: Once API is updated, consider removing fallback values
4. **Add Validation**: Add checks to ensure customer ID is valid before API calls

## Files Modified

- `lib/features/auth/models/user.dart`
- `lib/features/auth/dealer/models/dealer.dart`
- `lib/services/user_service.dart`
- `lib/core/di/injection.dart`
- `lib/features/Dashboard/Dealer/Cards/My_Orders/screens/my_orders_screen.dart`
- `lib/features/Dashboard/Dealer/Cards/Place_Order/Screen/cart_screen.dart`
- `lib/features/Dashboard/Dealer/Cards/Feedback/screens/feedback_screen.dart`
- `lib/features/Dashboard/Dealer/Screens/dashboard_dealer_screen.dart`

This implementation ensures that all customer-specific operations use the correct customer ID based on the currently logged-in user.