import 'package:flutter/material.dart';
class ResturauntSearch extends StatefulWidget {
	const ResturauntSearch({super.key});
	@override
	ResturauntSearchState createState() => ResturauntSearchState();
}
class ResturauntSearchState extends State<ResturauntSearch> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: Color(0xFFFFFFFF),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: IntrinsicHeight(
									child: Container(
										color: Color(0xFFFFFFFF),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Container(
																		margin: const EdgeInsets.only( left: 47),
																		child: Text(
																			"9:41",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 17,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																	Container(
																		width: 134,
																		height: 54,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/4l25xdws_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 44, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 8),
																		child: Text(
																			"Search",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 36,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 4, bottom: 4, left: 20, right: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(32),
																				color: Color(0xFFF7F7F7),
																			),
																			padding: const EdgeInsets.only( top: 10, bottom: 10, left: 16, right: 16),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(32),
																						),
																						width: 24,
																						height: 24,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(32),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/kcujm9po_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Food, groceries, etc.",
																						style: TextStyle(
																							color: Color(0xFFA09CAB),
																							fontSize: 16,
																						),
																					),
																					Container(
																						width: 24,
																						height: 24,
																						child: SizedBox(),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 28, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 8),
																		child: Text(
																			"Categories",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 28,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 13),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			color: Color(0xFFFFFFFF),
																			padding: const EdgeInsets.only( left: 16, right: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.only( top: 16, bottom: 16, left: 16),
																												margin: const EdgeInsets.only( right: 9),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/sllvw3au_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Ramen",
																															style: TextStyle(
																																color: Color(0xFF1C1B1F),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.only( top: 16, bottom: 16, left: 15),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/hr2w84ke_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Pizza",
																															style: TextStyle(
																																color: Color(0xFF1C1B1F),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.symmetric(vertical: 16),
																												margin: const EdgeInsets.only( right: 9),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20, left: 16),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/h45tmn19_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Container(
																															margin: const EdgeInsets.only( left: 16),
																															child: Text(
																																"Fast Food",
																																style: TextStyle(
																																	color: Color(0xFF1C1B1F),
																																	fontSize: 14,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.only( top: 16, bottom: 16, left: 15),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/351vbarh_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Healthy",
																															style: TextStyle(
																																color: Color(0xFF1C1B1F),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.only( top: 16, bottom: 16, left: 16),
																												margin: const EdgeInsets.only( right: 9),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/vq3cd8yi_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Salads",
																															style: TextStyle(
																																color: Color(0xFF1C1B1F),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.symmetric(vertical: 16),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20, left: 15),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/18bzayvl_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Container(
																															margin: const EdgeInsets.only( left: 15),
																															child: Text(
																																"Desserts",
																																style: TextStyle(
																																	color: Color(0xFF1C1B1F),
																																	fontSize: 14,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.only( top: 16, bottom: 16, left: 16),
																												margin: const EdgeInsets.only( right: 9),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/z22xgcf0_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Meat",
																															style: TextStyle(
																																color: Color(0xFF1C1B1F),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.only( top: 16, bottom: 16, left: 15),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/xbsysfch_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Asian",
																															style: TextStyle(
																																color: Color(0xFF1C1B1F),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.only( top: 16, bottom: 16, left: 16),
																												margin: const EdgeInsets.only( right: 9),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/l97n60gv_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Bakery",
																															style: TextStyle(
																																color: Color(0xFF1C1B1F),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFE5F9F1),
																												),
																												padding: const EdgeInsets.only( top: 16, bottom: 16, left: 15),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(16),
																															),
																															margin: const EdgeInsets.only( bottom: 20),
																															width: 24,
																															height: 24,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(16),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/nc8axxq0_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Italian",
																															style: TextStyle(
																																color: Color(0xFF1C1B1F),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 8),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(100),
																			color: Color(0xFF1C1B1F),
																		),
																		width: 139,
																		height: 5,
																		child: SizedBox(),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 10),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( left: 36, right: 36),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( top: 27),
																								margin: const EdgeInsets.only( right: 37),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Home",
																											style: TextStyle(
																												color: Color(0xFFA09CAB),
																												fontSize: 11,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( top: 27),
																								margin: const EdgeInsets.only( right: 37),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Browse",
																											style: TextStyle(
																												color: Color(0xFF00C773),
																												fontSize: 11,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( top: 27),
																								margin: const EdgeInsets.only( right: 37),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Orders",
																											style: TextStyle(
																												color: Color(0xFFA09CAB),
																												fontSize: 11,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( top: 27),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Profile",
																											style: TextStyle(
																												color: Color(0xFFA09CAB),
																												fontSize: 11,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
												],
											)
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}