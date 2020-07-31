import 'package:coolkicks/models/product.dart';
import 'package:coolkicks/providers/product-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate<Future<List>> {
  final shoes = ['Jordans', 'Air Force', 'Flip flops', 'Crocs'];

  final recentShoes = ['Jordans', 'Crocs'];

  // List<Product> allProducts = [];

  // Future getShoes(context) async {
  //   allProducts = Provider.of<ProductProvider>(context, listen: false).products;

  //   return allProducts;
  // }

  final List<Product> products;

  DataSearch({this.products});

  Widget content;

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // return FutureBuilder(
    //   future: getShoes(context),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return ListView.builder(
    //           itemCount: snapshot.data.length,
    //           itemBuilder: (context, index) =>
    //               ListTile(title: Text(snapshot.data[index]['title'])));
    //     } else {
    //       return CircularProgressIndicator();
    //     }
    //   },
    // );

    return Center(
      child: Container(
        height: 100,
        width: 100,
        child: Card(
          color: Colors.red,
        
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> shoeList = products;

    List _finalList = [];

    if (shoeList != null) {
      shoeList.forEach((product) {
        _finalList.add(product.title);
      });
      final suggestionList = query.isEmpty
          ? recentShoes
          : _finalList
              .where((p) =>
                  p.startsWith(query) ||
                  p.toString().toLowerCase().startsWith(query) ||
                  p.toString().toLowerCase().contains(query))
              .toList();
      content = ListView.builder(
      
          itemCount: suggestionList.length,
          itemBuilder: (context, index) => ListTile(
            onTap: (){
              showResults(context);
            },
                  title: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      ),
                  children: highlightOccurrences(suggestionList[index], query),
                ),
              )));
    } else {
      content = Container(
        child: Center(
          child: Text('Nothing here'),
        ),
      );
    }

    return content;
  }
}
