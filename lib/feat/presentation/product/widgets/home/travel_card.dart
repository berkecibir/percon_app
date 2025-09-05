import 'package:flutter/material.dart';
import 'package:percon_app/core/sizes/app_sizes.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/data/model/travel/travel_model.dart';
import 'package:easy_localization/easy_localization.dart';

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

  // Map country names to localization keys
  String _getCountryLocalizationKey(String country) {
    switch (country) {
      case 'Almanya':
        return AppTexts.germany;
      case 'Avusturya':
        return AppTexts.austria;
      case 'İsviçre':
        return AppTexts.switzerland;
      default:
        return country;
    }
  }

  // Map region names to localization keys
  String _getRegionLocalizationKey(String region) {
    switch (region) {
      // Germany regions
      case 'Berlin':
        return AppTexts.berlin;
      case 'Hamburg':
        return AppTexts.hamburg;
      case 'Bayern':
        return AppTexts.bavaria;
      case 'Sachsen':
        return AppTexts.saxony;
      case 'Hessen':
        return AppTexts.hesse;
      // Austria regions
      case 'Wien':
        return AppTexts.vienna;
      case 'Tirol':
        return AppTexts.tyrol;
      case 'Salzburg':
        return AppTexts.salzburg;
      case 'Steiermark':
        return AppTexts.styria;
      case 'Vorarlberg':
        return AppTexts.vorarlberg;
      // Switzerland regions
      case 'Zürich':
        return AppTexts.zurich;
      case 'Genève':
        return AppTexts.geneva;
      case 'Bern':
        return AppTexts.bern;
      case 'Luzern':
        return AppTexts.lucerne;
      case 'Valais':
        return AppTexts.valais;
      default:
        return region;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: DevicePadding.small.all,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 300;

          return SingleChildScrollView(
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
                              maxLines: isWideScreen ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          IconButton(
                            icon: Icon(
                              widget.travel.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.travel.isFavorite
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () {
                              widget.onToggleFavorite(widget.travel.id);
                            },
                          ),
                        ],
                      ),
                      DeviceSpacing.xsmall.height,
                      Text(
                        '${_getCountryLocalizationKey(widget.travel.country).tr()}, ${_getRegionLocalizationKey(widget.travel.region).tr()}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                        maxLines: isWideScreen ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      DeviceSpacing.xsmall.height,
                      Text(
                        '${widget.travel.startDate.day}/${widget.travel.startDate.month}/${widget.travel.startDate.year} - ${widget.travel.endDate.day}/${widget.travel.endDate.month}/${widget.travel.endDate.year}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF9E9E9E),
                        ),
                        maxLines: isWideScreen ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      DeviceSpacing.xsmall.height,
                      Text(
                        widget.travel.category,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (_isExpanded) ...[
                        DeviceSpacing.xsmall.height,
                        Text(
                          widget.travel.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
        },
      ),
    );
  }
}
