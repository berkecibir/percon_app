import 'package:flutter/material.dart';
import 'package:percon_app/core/sizes/app_sizes.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/data/model/travel/travel_model.dart';

class TravelCard extends StatefulWidget {
  final TravelModel travel;
  final Function(String) onToggleFavorite;

  const TravelCard({
    super.key,
    required this.travel,
    required this.onToggleFavorite,
  });

  @override
  State<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard> {
  bool _isExpanded = false;
  late bool _isFavorite; // local state

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.travel.isFavorite; // ilk değer modelden gelsin
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: DevicePadding.small.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: DevicePadding.small.all,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.travel.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite; // local state değişiyor
                        });
                        widget.onToggleFavorite(
                          widget.travel.id,
                        ); // Cubit/Repo’ya haber ver
                      },
                    ),
                  ],
                ),
                DeviceSpacing.xsmall.height,
                Text(
                  '${widget.travel.country}, ${widget.travel.region}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                DeviceSpacing.xsmall.height,
                Text(
                  '${widget.travel.startDate.day}/${widget.travel.startDate.month}/${widget.travel.startDate.year} - ${widget.travel.endDate.day}/${widget.travel.endDate.month}/${widget.travel.endDate.year}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                DeviceSpacing.xsmall.height,
                Text(
                  widget.travel.category,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                // Description will be shown when expanded
                if (_isExpanded) ...[
                  DeviceSpacing.xsmall.height,
                  Text(
                    widget.travel.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          // Expand/Collapse button
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: AppSizes.large,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
