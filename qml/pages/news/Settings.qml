import QtQuick 2.4
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import AppHandler 1.0
import Terminalaccess 1.0
    
Page {
    id: pageSettingsNews
	property int pageIndex

    header: PageHeader {
        id: headerSettings
        title: i18n.tr("Settings Page");
       StyleHints {
           foregroundColor: "#FFFFFF";
           backgroundColor: "#111111";
       }
            leadingActionBar.actions: [
                Action {
                    iconName: "back"
                    text: "Back"
                    onTriggered: {
                        pageStack.pop();
                    }
                }
            ]        
   }    
    
    

Rectangle {
    id:mainsettings
        anchors.fill: parent
        color: "#111111"
        anchors.topMargin: units.gu(6)
            
    
    Flickable {
        id: flickableSettings
        anchors.fill: parent
        contentHeight: settingsColumn.height
        flickableDirection: Flickable.VerticalFlick
        clip: true


        Column {
            id: settingsColumn
            anchors.fill: parent


ListModel { id: appNewsModel }

	Component.onCompleted: {
		for(var i = 0 ; i < AppHandler.appsinfo.length ; i++) {
			if(AppHandler.appsinfo[i].getProp("X-Ubuntu-Launcher") != "")
			{
				var item = AppHandler.appsinfo[i];
                appNewsModel.append({"name": item.name})
			}
		}
	}
        
            ListItem.Header {
                id: titlenewsAppsManagement
                text: "<font color=\"#ffffff\">"+i18n.tr("Management of news sources")+"</font>"
            }
    
    
    ListItem.Standard {
                id: transparentBackgroundNews
                anchors.top: titlenewsAppsManagement.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                divider.visible: false
                text: "<font color=\"#ffffff\">"+i18n.tr("Transparent background")+"</font>"
                control: Switch {
                checked: launchermodular.settings.newsBackgroundOpacity 
                onClicked: {
                    if( checked == true ) {
                        launchermodular.settings.newsBackgroundOpacity = true
                    }else{	
                        launchermodular.settings.newsBackgroundOpacity = false
                    }
                 }
                }
          }    
    
    
   		ListItem.Standard {
			id:titlenewsAppsFilter
            anchors.top: transparentBackgroundNews.bottom
            anchors.left: parent.left
            anchors.right: parent.right
			divider.visible: false
                	text: "<font color=\"#ffffff\">"+i18n.tr("Filter (XPath)")+"</font>"
			control: TextField{
				placeholderText:"category=\"something\""
				text:launchermodular.pageModel.get(pageIndex).data.filter
				onTextChanged: {
					launchermodular.pageModel.set(pageIndex, {"data":{"filter":text, "sources":launchermodular.pageModel.get(pageIndex).data.sources}})
					
					launchermodular.settings.newsConfigChanged()
					}
			}
		} 
 
    
        ListView {
            model: appNewsModel
            //anchors.fill: parent
            anchors.top: titlenewsAppsFilter.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: contentHeight

            delegate: ListItem.Standard {
                divider.visible: false
                text: "<font color=\"#ffffff\">"+name+"</font>"
                control: Switch {
                    checked:  launchermodular.pageModel.get(pageIndex).data.sources.includes(name)
                    onClicked: {
			if( checked == true ) {
				launchermodular.pageModel.set(pageIndex, {"data":{"filter":launchermodular.pageModel.get(pageIndex).data.filter,"sources": launchermodular.pageModel.get(pageIndex).data.sources+name+","}})
                        }else{
				launchermodular.pageModel.set(pageIndex, {"data":{"filter":launchermodular.pageModel.get(pageIndex).data.filter,"sources": launchermodular.pageModel.get(pageIndex).data.sources.replace(name+",","")}})
                        }
			console.log(launchermodular.pageModel.get(pageIndex).data.sources)
			console.log(launchermodular.pageModel.get(pageIndex).data.filter)
			launchermodular.settings.newsConfigChanged()
			}
                }
          }  
        }
    
            
            
        } // column
    } //flickable
 } //rectangle settings
     
    
    
}
