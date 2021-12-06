import QtQuick 2.4
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0
import "../widgets"
import QtQuick.Controls 2.2
import QtQuick.XmlListModel 2.0
import AppHandler 1.0
import Terminalaccess 1.0
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0
    
Item {
    id: news
        clip: true
    property bool reloading: false

     Component.onCompleted: {
	console.log(pageIndex)
	console.log(launchermodular.pageModel.get(pageIndex))
	console.log(launchermodular.pageModel.get(pageIndex).icon)
	console.log(launchermodular.pageModel.get(pageIndex).data)
	console.log(launchermodular.pageModel.get(pageIndex).name)
		var compatibleapps = ""
		for(var i = 0 ; i < AppHandler.appsinfo.length ; i++) {
			if(AppHandler.appsinfo[i].getProp("X-Ubuntu-Launcher") != "")
				compatibleapps += AppHandler.appsinfo[i].name+",";	
		}
	if(launchermodular.pageModel.get(pageIndex) && !launchermodular.pageModel.get(pageIndex).data) {
		launchermodular.pageModel.set(pageIndex, {"data": {"filter":"", "sources": compatibleapps}})
		
		console.log("settings pageindex")
	}
	else if(!launchermodular.pageModel.get(pageIndex).data.filter) {
		//launchermodular.pageModel.set(pageIndex, {"data": {"filter":"", "sources": ""}})
		launchermodular.pageModel.set(pageIndex, {"data": {"filter":"", "sources": compatibleapps}})
		console.log("settings pageindex filter")
	}
	console.log(launchermodular.pageModel.get(pageIndex).data.filter)
	console.log(launchermodular.pageModel.get(pageIndex).data.sources)

} 
     function reloadXmlNews(){
         news.reloading = true
    	xmlNewsList.query = (launchermodular.pageModel.get(pageIndex).data.filter != "") ? "/entries/entry["+launchermodular.pageModel.get(pageIndex).data.filter+"]" : "/entries/entry"
        xmlNewsList.xml = "";
	for(var i = 0 ; i < AppHandler.appsinfo.length ; i++) {
		if(AppHandler.appsinfo[i].getProp("X-Ubuntu-Launcher") != "")
		{
			var item = AppHandler.appsinfo[i];
			if(launchermodular.pageModel.get(pageIndex).data.sources.includes(item.name)) {
				Terminalaccess.run(AppHandler.appsinfo[i].getProp("Path")+"/"+AppHandler.appsinfo[i].getProp("X-Ubuntu-Launcher") +" 2> /dev/null");
				xmlNewsList.xml = Terminalaccess.outputUntilEnd();

			}
                
		}
	}
	if(xmlNewsList.xml == "") {
		xmlNewsList.xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><entries></entries>"
	
	}
                  news.reloading = false
    }        
       Connections {
	target: launchermodular.settings
	onNewsConfigChanged: {
		console.log("la settings news a changé")
		reloadXmlNews()
	} 
	}
	ListView {
		id:mylistview
        anchors.fill: parent
        cacheBuffer: contentHeight
        anchors {
            rightMargin: units.gu(2)
            leftMargin: units.gu(2)
            topMargin: units.gu(2)
        }  
        
           PullToRefresh {
                parent: mylistview
                refreshing: news.reloading
                onRefresh: news.reloadXmlNews();
               
            } 
        
        model:dummynewslist
		delegate:listItem
		focus:true
	}
    
    Component {
	id: listItem
	Item {
		id:wrapper
		height: if( wrapper.ListView.isCurrentItem ){ units.gu(18)+description.contentHeight*description.visible }else{ units.gu(13)+description.contentHeight*description.visible }
		width: parent.width
            
		MouseArea {
					anchors.fill: parent
					onClicked: {
						mylistview.currentIndex = index
					}	
				}
        
 Rectangle { 
    id: backgroundNews
    color: "#000000";
    anchors.fill: parent
    anchors.bottomMargin: units.gu(1)
    radius: units.gu(2)  
    border.color: bgcolor
    border.width: units.gu(0.3)
    opacity: launchermodular.settings.newsBackgroundOpacity ? 0.5 : 1
        
	}	
        
        
        Rectangle{
            anchors.top: backgroundNews.top
            anchors.right: backgroundNews.right
            anchors.topMargin: -units.gu(0.5)
            anchors.rightMargin: -units.gu(0.5)
            radius: units.gu(1) 
            width: units.gu(2) 
            height: units.gu(2) 
            color: bgcolor

                Image {
                    id: iconFeed
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width-units.gu(0.3)
                    height: parent.height-units.gu(0.3)
                    source: iconUri ? iconUri : "assets/fallbackicon.png"
                    fillMode: Image.PreserveAspectCrop
                    visible: false
                }
                OpacityMask {
                    anchors.fill: iconFeed
                    source: iconFeed
                    maskSource: Rectangle {
                        width: iconFeed.width
                        height: iconFeed.height
                        radius: units.gu(1)
                        visible: false
                    }
                }
                
        }
        
        
		Column {
            id: columnHeader
            anchors.fill: backgroundNews
            anchors.leftMargin: units.gu(1)
            anchors.topMargin: units.gu(1)
            anchors.bottomMargin: units.gu(1)
            
			Row {
                    Item {
                        id: imageNews
                        width: if( wrapper.ListView.isCurrentItem ){ columnHeader.width }else{ units.gu(11) }
                        height: if( wrapper.ListView.isCurrentItem ){ units.gu(15) }else{ units.gu(11) }

                        
                        Image {
                            id: imgIcons
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width-units.gu(1)
                            height: parent.height-units.gu(1)
                            source: (media)? media : ((iconUri)? iconUri : "assets/fallbackicon.png")
                            visible: false
                            fillMode: Image.PreserveAspectCrop
                        }
                        
                        UbuntuShape {
                            source: imgIcons
                            width: parent.width-units.gu(1)
                            height: parent.height-units.gu(1)
                            radius : "medium"
                            sourceFillMode: UbuntuShape.PreserveAspectCrop
                                
                            Rectangle{
                                anchors.fill: parent
                                radius : units.gu(2)
                                color: if( wrapper.ListView.isCurrentItem ){ "black" }else{ "transparent" }
                                opacity: if( wrapper.ListView.isCurrentItem ){ 0.3 }else{ 1 }
                            }
                        }
                        
                    }
				Rectangle {
                    id: titleDateAuthors
                    anchors.left: if( wrapper.ListView.isCurrentItem ){ parent.left }else{ imageNews.right }
                    anchors.bottom: if( wrapper.ListView.isCurrentItem ){ imageNews.top }

					Text {
						id: dateauthors
						text: new Date(timestamp).toLocaleString(Qt.locale(),Locale.ShortFormat)+" "+i18n.tr("by")+" "+author
						wrapMode:Text.WordWrap
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        width: if( wrapper.ListView.isCurrentItem ){ wrapper.width-units.gu(2) }else{ wrapper.width-imageNews.width-units.gu(2) }
                        color: "#AEA79F"
                        font.pointSize: units.gu(1)
                    }
					Text {
						text: title
                        anchors.top: dateauthors.bottom
                        width: if( wrapper.ListView.isCurrentItem ){ wrapper.width-units.gu(2) }else{ wrapper.width-imageNews.width-units.gu(2) }
						wrapMode:Text.WordWrap
                        elide: Text.ElideRight
                        maximumLineCount: 3
                        color: launchermodular.settings.textColor
                        //font.pointSize: units.gu(1.5)    
                        font.bold: true
					}
				}
				
			}
			Text { 
				id:description
                text: shortDesc
				width:wrapper.width-units.gu(2)
                height: contentHeight
				wrapMode:Text.WordWrap
				visible:wrapper.ListView.isCurrentItem
                color: launchermodular.settings.textColor
                font.pointSize: units.gu(1.1)   
                maximumLineCount: 4
                    
				MouseArea {
					anchors.fill: parent
					onClicked: {
						console.log("clicked")
						pageStack.push(Qt.resolvedUrl("news/Full.qml"),{fullText: longDesc,title:title,url: url,headertext: dateauthors.text})

					}
				}
			}
            
		}
        
        
	}
    }
XmlListModel {

id: xmlNewsList
    xml: ""
    query: (launchermodular.pageModel.get(pageIndex).data.filter != "") ? "/entries/entry["+launchermodular.pageModel.get(pageIndex).data.filter+"]" : "/entries/entry"
        
    XmlRole { name: "bgcolor"; query: "@color/string()" }
    XmlRole { isKey: false; name: "title"; query: "title/string()" }
    XmlRole { isKey: false; name: "shortDesc"; query: "shortDesc/string()" }
    XmlRole { isKey: false; name: "longDesc"; query: "longDesc/string()" }
    XmlRole { isKey: false; name: "url"; query: "url/string()" }
    XmlRole { isKey: false; name: "iconUri"; query: "iconUri/string()" }
    XmlRole { isKey: false; name: "timestamp"; query: "timestamp/number()" }
    XmlRole { isKey: false; name: "category"; query: "category/string()" }
    XmlRole { isKey: false; name: "author"; query: "author/string()" }
    XmlRole { isKey: false; name: "media"; query: "media/string()" }
	
	Component.onCompleted: {
		news.reloadXmlNews();
	}
	onStatusChanged: { if(status !== XmlListModel.Ready) return;
		console.log("datachanged")
		dummynewslist.fill();
	}
}
ListModel {
	id:dummynewslist
	function fill() {	
		dummynewslist.clear();
		var reordered=[]
		for(var i=0;i< xmlNewsList.count;i++) {
			reordered.push({"index":i,"time":xmlNewsList.get(i).timestamp})
		}
		reordered.sort(function(a,b) {
			return - (a.time - b.time)
		}
		)
			
		for(var i=0;i<reordered.length;i++) {
			dummynewslist.append(xmlNewsList.get(reordered[i].index))
		}
	}


}
}
