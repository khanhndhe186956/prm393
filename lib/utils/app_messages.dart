class AppMessages {
  AppMessages._();

  static const noRecords = 'No matching records found';
  static const invalidCredentials = 'Invalid email or password';

  static String fieldRequired(String fieldName) {
    return 'The $fieldName field is required.';
  }

  static const residentUpdated = 'Resident information has been updated successfully.';
  static const memberAdded = 'New member has been added to the household';
  static const feeDeducted = 'Service fee has been deducted from your wallet successfully.';
  static const insufficientBalance =
      'Wallet balance is insufficient. Please top up to avoid outstanding charges.';
  static const invalidAmount = 'Invalid amount value';
  static const paymentSuccess = 'Payment completed successfully.';
  static const requestCreated = 'Maintenance request submitted successfully.';
  static const billCreated = 'Bill created successfully.';

  static String billNotification(String month, String amount) {
    return 'Your bill for $month is $amount. Payment will be automatically processed on the 5th.';
  }

  static String deleteApartmentConfirm(String apartmentId) {
    return 'You are about to delete apartment $apartmentId. This action cannot be undone. Do you wish to continue?';
  }
}
