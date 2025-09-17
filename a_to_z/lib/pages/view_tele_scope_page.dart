import 'package:a_to_z/pages/telescope_detaile_page.dart';
import 'package:a_to_z/providers/talescope_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ViewTeleScopePage extends StatefulWidget {
  static const String routeName = 'detailtelescope';
  const ViewTeleScopePage({super.key});

  @override
  State<ViewTeleScopePage> createState() => _ViewTeleScopePageState();
}

class _ViewTeleScopePageState extends State<ViewTeleScopePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TalescopeProvider>(
        builder: (context, provider, child){
          return ListView.builder(
            itemCount: provider.telescopeList.length,
            itemBuilder: (context, index){
            final telescope = provider.telescopeList[index];

            return InkWell(
              onTap: (){
                context.pushNamed(TelescopeDetailePage.routeName, extra: telescope.id);
              },

              child: Card(
                elevation: 0,
                color: Colors.transparent,

                child: Row(
                  children: [
                    CachedNetworkImage(
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      imageUrl: telescope.thumbnail.downloadUrl,
                      placeholder: (context, url) => 
                      Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      ),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(telescope.brand.name, style: TextStyle(fontSize: 16),),
                              Text(telescope.model, style: TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis),),
                            ],
                          ),
                          ))
                  ],
                ),
              ),
            );
            }
          );
        }
        )
    );
  }
}