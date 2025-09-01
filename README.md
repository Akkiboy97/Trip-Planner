Project Structure & Architecture
UI Design: Combination of Storyboard (for main flows, navigation) and Programmatic UI (for custom views, reusable components).
Architectures Used:
MVC (Model–View–Controller) → used in controllers like TripListViewController, CreateTripViewController.
MVVM (Model–View–ViewModel) → applied in parts of the project for better data-binding and separation of concerns (e.g., APIClient + Trip models with ViewModels for trip data).
Reasoning: This hybrid approach makes the project easy to scale — MVC for quick iteration and MVVM where data/state management is crucial.


==> TripListViewController.swift

Feature / Module Covered
This screen displays the list of all trips for the user.
Users can view trips and create a new trip.
On tapping a trip → navigates to the Trip Detail screen.

Dependencies / Setup Notes
Uses UIKit (UITableView, UINavigationController).
Requires APIClient for fetching trips (fetchTrips endpoint).
Requires TripTableViewCell, TripViewController, and CreateTripViewController.

API Integration
Calls api.fetchTrips { ... } to retrieve trips.
Handles success → reloads UITableView.
Handles failure → shows alert (Failed to fetch trips).
Endpoints to document in README:
GET /trips → fetch trips list.

Navigation Flow
Right navigation bar button "New" → opens CreateTripViewController.
Selecting a trip row → navigates to TripViewController (trip details).
Uses Delegates + Closures for passing newly created trip back to list.

UI / UX Behavior
Activity Indicator (UIActivityIndicatorView) for loading state.
Alerts shown for API failure.
"View All" button inside each cell opens the Trip Detail screen.

==> TripViewController.swift

Feature / Module Covered
This is the Trip Details screen.
Displays details of a selected trip with sections:
Activities
Hotels
Flights
Allows users to add items to each section (via an alert input form).
Items can have title, subtitle, price, and an image (sample Unsplash URL used).
Items can also be removed.


UI/UX Behavior
Uses a dynamic UITableView with multiple sections (one per TripItemType).
Shows a custom header with:
Trip info (via HeaderView)
"Add Activities / Hotels / Flights" buttons (SectionCardView).
Collaboration and Share button actions (currently placeholders).
Empty states:
Shows "No request yet" when a section has no items.
ItemCell:
Custom card-style cell.
Displays thumbnail (with image loader), title, subtitle, price.
Includes Remove button (red).


Data Handling
Uses TripViewModel to manage trip data.
Maintains elements dictionary for TripItemType → [TripElement].
Provides methods to add, remove, and list items per type.
Uses onDataChanged closure for live updates.
API / Data Notes
Adding items currently uses local storage only (in-memory), not backend.
Image URLs are sample placeholders from Unsplash (document this in README).

Navigation Flow
Comes from TripListViewController (when user taps on a trip).
Contains collaboration/share placeholders (to expand later).


Dependencies / Setup
Requires TripViewModel, TripItemType, TripElement, HeaderView, SectionCardView, ImageLoader.
Built fully with UIKit, AutoLayout (no Storyboard).

==> CreateTripViewController.swift


Feature / Module Covered
Create New Trip flow:
Select city, start date, and end date.
Enter trip name, style (solo, family, group, couple), and description.
Submit form to create a trip via API.
Uses a two-step form:
Basic info card → city & dates.
Trip details form → name, style, description.
Shows confirmation popup (PopupViewController) on success or failure.
Integrates with trip list via TripListViewControllerDelegate (new trip added to the list immediately).

UI/UX Behavior
Background image, intro text, and form card view for clean UI.
Date picker (DateRangePickerViewController) for start/end date.
City picker (CityPickerViewController) for location.
Style picker (UIPickerView) for selecting travel style.
"Next" button disabled until all required fields are valid.
Validation ensures no empty inputs.

Data Handling & API
Creates a Trip object with provided details.
Calls api.createTrip(trip) → backend request to persist.
Handles success with ✅ popup, failure with ❌ popup.
Expected API endpoint:
POST /trips → body: { title, description, tripType, location, startDate, endDate }.
Returns created Trip object + status message.

Navigation Flow
Starts from Trip List screen (via "New" button).
After successful creation:
Trip is passed back to Trip List and displayed instantly.
User is navigated back to the list.

Dependencies / Setup
Requires:
APIClient (network layer).
PopupViewController (confirmation popup).
DateRangePickerViewController (date input).
CityPickerViewController (location input).

Uses delegate protocols:
TripListViewControllerDelegate (to notify list).
TripDetailsDelegate (for trip details form).


