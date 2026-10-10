import 'package:flutter/material.dart';
class More extends StatefulWidget {
	const More({super.key});
	@override
	MoreState createState() => MoreState();
}
class MoreState extends State<More> {
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
										color: Color(0xFF0000FF),
										width: double.infinity,
										height: double.infinity,
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												IntrinsicHeight(
													child: Container(
														margin: const EdgeInsets.only( left: 128),
														width: double.infinity,
														child: Row(
															children: [
																Expanded(
																	child: IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( right: 74),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 36),
																						width: double.infinity,
																						child: Text(
																							"Generate mobile app wireframes with AI",
																							style: TextStyle(
																								color: Color(0xFFFFFFFF),
																								fontSize: 90,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					InkWell(
																						onTap: () { print('Pressed'); },
																						child: IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										borderRadius: BorderRadius.circular(16),
																										color: Color(0xFFFFFFFF),
																									),
																									child: Stack(
																										clipBehavior: Clip.none,
																										children: [
																											Padding(
																												padding: const EdgeInsets.only( top: 18, bottom: 18, left: 25, right: 25),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															".    Open plugin",
																															style: TextStyle(
																																color: Color(0xFF0000FF),
																																fontWeight: FontWeight.bold,
																															),
																														),
																													]
																												),
																											),
																											Positioned(
																												top: 13,
																												left: 14,
																												width: 44,
																												height: 44,
																												child: Container(
																													width: 44,
																													height: 44,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/jqrzdz0r_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																),
																IntrinsicHeight(
																	child: Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(2),
																			color: Color(0xFFFFFFFF),
																			boxShadow: [
																				BoxShadow(
																					color: Color(0x4D000000),
																					blurRadius: 1,
																					offset: Offset(0, 0),
																				),
																			],
																		),
																		padding: const EdgeInsets.symmetric(vertical: 24),
																		margin: const EdgeInsets.only( right: 39),
																		width: 357,
																		child: Column(
																			crossAxisAlignment: CrossAxisAlignment.start,
																			children: [
																				IntrinsicWidth(
																					child: IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 14, left: 19),
																							child: Stack(
																								clipBehavior: Clip.none,
																								children: [
																									Column(
																										children: [
																											Container(
																												width: 337,
																												child: Text(
																													"Design home screen of the mobile app for ordering food from resturaunts",
																													style: TextStyle(
																														color: Color(0xFF001541),
																														fontSize: 16,
																													),
																												),
																											),
																										]
																									),
																									Positioned(
																										top: 0,
																										right: 0,
																										child: IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													color: Color(0xFFFFFFFF),
																													padding: const EdgeInsets.only( top: 4, bottom: 4, left: 20, right: 20),
																													transform: Matrix4.translationValues(0, -29, 0),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Row(
																																		children: [
																																			IntrinsicWidth(
																																				child: IntrinsicHeight(
																																					child: Container(
																																						decoration: BoxDecoration(
																																							borderRadius: BorderRadius.circular(5),
																																							color: Color(0xFFF5F5F5),
																																						),
																																						padding: const EdgeInsets.only( top: 2, bottom: 2, left: 5, right: 5),
																																						margin: const EdgeInsets.only( right: 9),
																																						child: Column(
																																							crossAxisAlignment: CrossAxisAlignment.start,
																																							children: [
																																								Container(
																																									width: 9,
																																									height: 15,
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/lmpqiror_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								),
																																							]
																																						),
																																					),
																																				),
																																			),
																																			Container(
																																				margin: const EdgeInsets.only( right: 204),
																																				child: Text(
																																					"Banani AI",
																																					style: TextStyle(
																																						color: Color(0xFF333333),
																																						fontSize: 13,
																																						fontWeight: FontWeight.bold,
																																					),
																																				),
																																			),
																																			Container(
																																				width: 30,
																																				height: 30,
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/31hf3rb7_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			),
																																		]
																																	),
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: Color(0xFF0000FF),
																						padding: const EdgeInsets.symmetric(vertical: 14),
																						margin: const EdgeInsets.only( bottom: 16),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Container(
																									margin: const EdgeInsets.only( bottom: 2, left: 19),
																									child: Text(
																										"Banani",
																										style: TextStyle(
																											color: Color(0xFF333333),
																											fontSize: 13,
																											fontWeight: FontWeight.bold,
																										),
																									),
																								),
																								Container(
																									margin: const EdgeInsets.only( left: 19),
																									width: 337,
																									child: Text(
																										"What kind of navigation do you want to have?",
																										style: TextStyle(
																											color: Color(0xFF001541),
																											fontSize: 16,
																										),
																									),
																								),
																							]
																						),
																					),
																				),
																				Container(
																					margin: const EdgeInsets.only( bottom: 2, left: 19),
																					child: Text(
																						"You",
																						style: TextStyle(
																							color: Color(0xFF333333),
																							fontSize: 13,
																							fontWeight: FontWeight.bold,
																						),
																					),
																				),
																				Container(
																					margin: const EdgeInsets.only( bottom: 13, left: 19),
																					child: Text(
																						"Use doordash as a reference",
																						style: TextStyle(
																							color: Color(0xFF001541),
																							fontSize: 16,
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: Color(0xFF0000FF),
																						padding: const EdgeInsets.symmetric(vertical: 16),
																						margin: const EdgeInsets.only( bottom: 21),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Container(
																									margin: const EdgeInsets.only( bottom: 2, left: 19),
																									child: Text(
																										"Banani",
																										style: TextStyle(
																											color: Color(0xFF333333),
																											fontSize: 13,
																											fontWeight: FontWeight.bold,
																										),
																									),
																								),
																								Container(
																									margin: const EdgeInsets.only( left: 19),
																									width: 337,
																									child: Text(
																										"Here’s your home screen design! Let me know if want to edit something.",
																										style: TextStyle(
																											color: Color(0xFF001541),
																											fontSize: 16,
																										),
																									),
																								),
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						decoration: BoxDecoration(
																							border: Border.all(
																								color: Color(0xFFE5E5E5),
																								width: 1,
																							),
																							borderRadius: BorderRadius.circular(10),
																							color: Color(0xFFFFFFFF),
																							boxShadow: [
																								BoxShadow(
																									color: Color(0x08000000),
																									blurRadius: 5,
																									offset: Offset(0, 5.032863616943359),
																								),
																							],
																						),
																						padding: const EdgeInsets.only( top: 10, bottom: 10, left: 19, right: 19),
																						margin: const EdgeInsets.symmetric(horizontal: 20),
																						width: double.infinity,
																						child: Row(
																							mainAxisAlignment: MainAxisAlignment.spaceBetween,
																							children: [
																								Text(
																									"Message or comment",
																									style: TextStyle(
																										color: Color(0xFF808AA0),
																										fontSize: 16,
																									),
																								),
																								InkWell(
																									onTap: () { print('Pressed'); },
																									child: IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(37),
																													color: Color(0xFF0000FF),
																												),
																												padding: const EdgeInsets.all(9),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															width: 20,
																															height: 20,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/5iy27af9_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														),
																													]
																												),
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
																IntrinsicHeight(
																	child: Container(
																		decoration: BoxDecoration(
																			border: Border.all(
																				color: Color(0xFF0000FF),
																				width: 1,
																			),
																			color: Color(0xFFFFFFFF),
																		),
																		padding: const EdgeInsets.only( bottom: 1),
																		width: 162,
																		child: Column(
																			crossAxisAlignment: CrossAxisAlignment.start,
																			children: [
																				IntrinsicHeight(
																					child: Container(
																						margin: const EdgeInsets.only( bottom: 1),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicHeight(
																									child: Container(
																										color: Color(0xFFFFFFFF),
																										padding: const EdgeInsets.only( top: 12, bottom: 12, left: 38),
																										width: double.infinity,
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Text(
																													"9:41",
																													style: TextStyle(
																														color: Color(0xFF1C1B1F),
																														fontSize: 13,
																														fontWeight: FontWeight.bold,
																													),
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
																										child: Row(
																											children: [
																												Container(
																													margin: const EdgeInsets.only( left: 16, right: 3),
																													width: 19,
																													height: 19,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/ly0r0gto_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																												Text(
																													"Park Way 145",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 13,
																														fontWeight: FontWeight.bold,
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
																						padding: const EdgeInsets.only( top: 7, bottom: 7, left: 17),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicWidth(
																									child: IntrinsicHeight(
																										child: Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(26),
																												color: Color(0xFFFFFFFF),
																												boxShadow: [
																													BoxShadow(
																														color: Color(0x12000000),
																														blurRadius: 9,
																														offset: Offset(0, 3.2726707458496094),
																													),
																												],
																											),
																											padding: const EdgeInsets.symmetric(vertical: 8),
																											child: Row(
																												children: [
																													Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(26),
																														),
																														margin: const EdgeInsets.only( left: 12, right: 84),
																														width: 19,
																														height: 19,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(26),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/um2k7k7m_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													Text(
																														"Search",
																														style: TextStyle(
																															color: Color(0xFFA09CAB),
																															fontSize: 13,
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
																						color: Color(0xFFFFFFFF),
																						padding: const EdgeInsets.symmetric(vertical: 13),
																						width: double.infinity,
																						child: Row(
																							mainAxisAlignment: MainAxisAlignment.center,
																							children: [
																								IntrinsicWidth(
																									child: IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.only( left: 3, right: 3),
																											margin: const EdgeInsets.only( right: 4),
																											child: Column(
																												children: [
																													Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(26),
																														),
																														margin: const EdgeInsets.only( bottom: 6),
																														width: 52,
																														height: 52,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(26),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/h8d8utaw_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													Text(
																														"Acclaimed",
																														style: TextStyle(
																															color: Color(0xFF1C1B1F),
																															fontSize: 10,
																															fontWeight: FontWeight.bold,
																														),
																													),
																												]
																											),
																										),
																									),
																								),
																								IntrinsicWidth(
																									child: IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.only( left: 4, right: 4),
																											child: Column(
																												children: [
																													Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(26),
																														),
																														margin: const EdgeInsets.only( bottom: 6),
																														width: 52,
																														height: 52,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(26),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/css5xnyn_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													Text(
																														"Healthy",
																														style: TextStyle(
																															color: Color(0xFF1C1B1F),
																															fontSize: 10,
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
																						color: Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 17, left: 16),
																						margin: const EdgeInsets.only( bottom: 1),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"Fastest",
																									style: TextStyle(
																										color: Color(0xFF1C1B1F),
																										fontSize: 16,
																										fontWeight: FontWeight.bold,
																									),
																								),
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 8, bottom: 8, left: 17),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Container(
																									decoration: BoxDecoration(
																										borderRadius: BorderRadius.circular(13),
																										color: Color(0xFFEFF1F5),
																									),
																									margin: const EdgeInsets.only( bottom: 10),
																									width: 145,
																									height: 115,
																									child: SizedBox(),
																								),
																								IntrinsicHeight(
																									child: Container(
																										padding: const EdgeInsets.only( bottom: 1),
																										width: double.infinity,
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													margin: const EdgeInsets.only( bottom: 2),
																													child: Text(
																														"Morning Delights Café",
																														style: TextStyle(
																															color: Color(0xFF1C1B1F),
																															fontSize: 13,
																															fontWeight: FontWeight.bold,
																														),
																													),
																												),
																												IntrinsicHeight(
																													child: Container(
																														width: double.infinity,
																														child: Row(
																															children: [
																																IntrinsicWidth(
																																	child: IntrinsicHeight(
																																		child: Container(
																																			margin: const EdgeInsets.only( right: 12),
																																			child: Row(
																																				children: [
																																					IntrinsicWidth(
																																						child: IntrinsicHeight(
																																							child: Container(
																																								margin: const EdgeInsets.only( right: 2),
																																								child: Row(
																																									children: [
																																										Container(
																																											margin: const EdgeInsets.only( right: 3),
																																											child: Text(
																																												"4.9",
																																												style: TextStyle(
																																													color: Color(0xFF1C1B1F),
																																													fontSize: 11,
																																													fontWeight: FontWeight.bold,
																																												),
																																											),
																																										),
																																										Container(
																																											width: 16,
																																											height: 16,
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/vuxv6hnh_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										),
																																									]
																																								),
																																							),
																																						),
																																					),
																																					Text(
																																						"(103)",
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
																																Text(
																																	"2.3km",
																																	style: TextStyle(
																																		color: Color(0xFFA09CAB),
																																		fontSize: 11,
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
																						padding: const EdgeInsets.only( top: 17, left: 16),
																						margin: const EdgeInsets.only( bottom: 1),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"Recommended",
																									style: TextStyle(
																										color: Color(0xFF1C1B1F),
																										fontSize: 16,
																										fontWeight: FontWeight.bold,
																									),
																								),
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: Color(0xFFFFFFFF),
																						width: double.infinity,
																						child: Stack(
																							clipBehavior: Clip.none,
																							children: [
																								Padding(
																									padding: const EdgeInsets.only( top: 99),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											IntrinsicHeight(
																												child: Container(
																													color: Color(0xFFFFFFFF),
																													padding: const EdgeInsets.symmetric(vertical: 8),
																													margin: const EdgeInsets.only( bottom: 8),
																													width: double.infinity,
																													child: Row(
																														mainAxisAlignment: MainAxisAlignment.center,
																														children: [
																															IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		padding: const EdgeInsets.only( left: 5, right: 5),
																																		margin: const EdgeInsets.only( right: 30),
																																		child: Column(
																																			children: [
																																				Container(
																																					margin: const EdgeInsets.only( bottom: 2),
																																					width: 19,
																																					height: 19,
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/jxe7no2e_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				),
																																				Text(
																																					"Home",
																																					style: TextStyle(
																																						color: Color(0xFF000000),
																																						fontSize: 8,
																																						fontWeight: FontWeight.bold,
																																					),
																																				),
																																			]
																																		),
																																	),
																																),
																															),
																															IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		padding: const EdgeInsets.only( left: 2, right: 2),
																																		child: Column(
																																			children: [
																																				Container(
																																					margin: const EdgeInsets.only( bottom: 2),
																																					width: 19,
																																					height: 19,
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/zhgvloil_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				),
																																				Text(
																																					"Browse",
																																					style: TextStyle(
																																						color: Color(0xFFA09CAB),
																																						fontSize: 8,
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
																								Positioned(
																									bottom: 0,
																									right: 0,
																									width: 145,
																									height: 150,
																									child: Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(13),
																											color: Color(0xFFEFF1F5),
																										),
																										width: 145,
																										height: 150,
																										child: SizedBox(),
																									),
																								),
																								Positioned(
																									bottom: 0,
																									left: 0,
																									right: 0,
																									child: IntrinsicHeight(
																										child: Container(
																											color: Color(0xFFFFFFFF),
																											padding: const EdgeInsets.only( top: 6),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.end,
																												children: [
																													Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(81),
																															color: Color(0xFF1C1B1F),
																														),
																														width: 66,
																														height: 2,
																														child: SizedBox(),
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
											]
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