import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int starCount;
  final double rating;
  final Function(double) onRatingChanged;
  final bool interactive;

  StarRating({
    this.starCount = 5,
    this.rating = 0.0,
    required this.onRatingChanged,
    this.interactive = true,
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  double _currentRating = 0.0;
  double _hoverRating = -1;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  void _setRating(double rating) {
    setState(() {
      _currentRating = rating;
    });
    widget.onRatingChanged(rating);
  }

  void _setHoverRating(double rating) {
    setState(() {
      _hoverRating = rating;
    });
  }

  Widget buildRatingStars(double? rating) {
    // If the rating is null, display unrated stars
    if (rating == null) {
      return const Row(
        children: [
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
          Icon(Icons.star_border),
        ],
      );
    }

    // Calculate the number of filled stars based on the rating
    int filledStars = rating.round();
    List<Icon> stars = List.generate(
      5,
      (index) => Icon(
        index < filledStars ? Icons.star : Icons.star_border,
      ),
    );

    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        return MouseRegion(
          onEnter: (_) {
            if (widget.interactive) {
              _setHoverRating(index + 1.0);
            }
          },
          onExit: (_) {
            if (widget.interactive) {
              _setHoverRating(-1);
            }
          },
          child: GestureDetector(
            onTap: () {
              if (widget.interactive) {
                _setRating(index + 1.0);
              }
            },
            child: Icon(
              index < (_hoverRating == -1 ? _currentRating : _hoverRating) ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
          ),
        );
      }),
    );
  }
}

// import 'package:flutter/material.dart';

// class StarRating extends StatefulWidget {
//   final int starCount;
//   final double rating;
//   final Function(double) onRatingChanged;

//   StarRating({this.starCount = 5, this.rating = 0.0, required this.onRatingChanged});

//   @override
//   _StarRatingState createState() => _StarRatingState();
// }

// class _StarRatingState extends State<StarRating> {
//   double _currentRating = 0.0;
//   double _hoverRating = -1;

//   @override
//   void initState() {
//     super.initState();
//     _currentRating = widget.rating;
//   }

//   void _setRating(double rating) {
//     setState(() {
//       _currentRating = rating;
//     });
//     widget.onRatingChanged(rating);
//   }

//   void _setHoverRating(double rating) {
//     setState(() {
//       _hoverRating = rating;
//     });
//   }

//   Widget buildRatingStars(double? rating) {
//   // If the rating is null, display unrated stars
//   if (rating == null) {
//     return const Row(
//       children: [
//         Icon(Icons.star_border),
//         Icon(Icons.star_border),
//         Icon(Icons.star_border),
//         Icon(Icons.star_border),
//         Icon(Icons.star_border),
//       ],
//     );
//   }

//   // Calculate the number of filled stars based on the rating
//   int filledStars = rating.round();
//   List<Icon> stars = List.generate(
//     5,
//     (index) => Icon(
//       index < filledStars ? Icons.star : Icons.star_border,
//     ),
//   );

//   return Row(children: stars);
// }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(widget.starCount, (index) {
//         return MouseRegion(
//           onEnter: (_) => _setHoverRating(index + 1.0),
//           onExit: (_) => _setHoverRating(-1),
//           child: GestureDetector(
//             onTap: () {
//               _setRating(index + 1.0);
//             },
//             child: Icon(
//               index < (_hoverRating == -1 ? _currentRating : _hoverRating) ? Icons.star : Icons.star_border,
//               color: Colors.amber,
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
