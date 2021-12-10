import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import MySettings 1.0
import AppHandler 1.0
import "../widgets"
import QtQuick.Controls 2.2
import "../components"

Item {
    id: cinema
	property string apikey: "" 

Flickable {
    id: flickable
    anchors.fill: parent
    contentHeight: units.gu(30)+gview.height
    flickableDirection: Flickable.VerticalFlick
    clip: true
    maximumFlickVelocity : units.gu(10)*100//TODO make it a settings


    Column {
        id: textCarrousselColumn
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: units.gu(2)
            leftMargin: units.gu(2)
            topMargin: units.gu(2)
        }


        Rectangle{
            id: textCarousel
            height: units.gu(4)
            Icon {
               id: iconFeatured
                width: units.gu(2)
                height: units.gu(2)
                name: "keypad"
                color: launchermodular.settings.textColor
            }
            Label {
                id: titleCarousel
                anchors.left: iconFeatured.right
                anchors.leftMargin: units.gu(1)
                text: i18n.tr("Featured")
                color: launchermodular.settings.textColor
            }
        }
    }
    Column {
        id: carrouselColumn
        anchors {
            left: parent.left
            right: parent.right
            top: textCarrousselColumn.bottom
            topMargin: units.gu(4)
        }
        height: units.gu(20)

Rectangle {
        id: carrouselPoster
        width: parent.width
        height: units.gu(20)
        color: "transparent"

        PathView {
            id: pathView
            anchors.fill: parent
            model: modelTMDB.model
            delegate: myDelegate
            dragMargin: 300

            snapMode: PathView.SnapToItem
            maximumFlickVelocity: width

            preferredHighlightBegin:0.5
            preferredHighlightEnd:0.5

            clip: true

            path: Path {
                id:flowViewPath

                readonly property real yCoord: pathView.height/2

                startX: 0
                startY: flowViewPath.yCoord

                PathAttribute{name:"elementZ"; value: 0}
                PathAttribute{name:"elementScale"; value: 0.5}

                PathLine {
                    x: pathView.width*0.5
                    y: flowViewPath.yCoord
                }

                PathAttribute{name:"elementZ";value:100}
                PathAttribute{name:"elementScale";value:1.0}

                PathLine {
                    x: pathView.width
                    y: flowViewPath.yCoord
                }

                PathAttribute{name:"elementZ";value:0}
                PathAttribute{name:"elementScale";value:0.5}

                PathPercent{value:1.0}
            }
        }

        Component {
            id: myDelegate
            Item {
                width: units.gu(12)
                height: units.gu(20)
                scale: PathView.elementScale
                z: PathView.elementZ

                Image {
                    id: imgIcons
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: parent.height
                    source: "https://image.tmdb.org/t/p/w600_and_h900_bestv2"+model.poster_path
                    visible: false
                    fillMode: Image.PreserveAspectCrop
                }

                UbuntuShape {
                    source: imgIcons
                    width: parent.width
                    height: parent.height
                    radius : "medium"
                    sourceFillMode: UbuntuShape.PreserveAspectCrop
                }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Qt.openUrlExternally( "https://www.themoviedb.org/movie/"+model.id+"-"+model.original_title.replace(' ', '-')+"?language="+Qt.locale().name.split("_")[0] );
                                }
            } // Item
        }


    JSONListModel {
        id: modelTMDB
        source: "https://api.themoviedb.org/3/movie/now_playing?api_key="+cinema.apikey+"&language="+Qt.locale().name.split("_")[0]+"&page=1&region="+Qt.locale().name.split("_")[1];
        query: "$.results[:9]"
    }

    }
}
    Column {
        id: commingColumn
        anchors.top: carrouselColumn.bottom
        anchors {
            left: parent.left
            right: parent.right
            rightMargin: units.gu(2)
            leftMargin: units.gu(2)
            topMargin: units.gu(2)
        }

        Rectangle{
            id: textComingSoon
            height: units.gu(4)
            Icon {
               id: iconComingSoon
                width: units.gu(2)
                height: units.gu(2)
                name: "keypad"
                color: launchermodular.settings.textColor
            }
            Label {
                id: titleComingSoon
                anchors.left: iconComingSoon.right
                anchors.leftMargin: units.gu(1)
                text: i18n.tr("Coming soon")
                color: launchermodular.settings.textColor
            }
        }


    GridView {
        id: gview
        anchors {
            top: textComingSoon.bottom
            left: parent.left
            right: parent.right
        }
        interactive: false
        cellHeight: iconbasesize+units.gu(9)
        property real iconbasesize: units.gu(13)
        cellWidth: Math.floor(width/Math.floor(width/iconbasesize))
        height: contentHeight+units.gu(2)

        focus: true
        model: modelCommingTMDB.model


    JSONListModel {
        id: modelCommingTMDB
        source: "https://api.themoviedb.org/3/movie/upcoming?api_key="+cinema.apikey+"&language="+Qt.locale().name.split("_")[0]+"&page=1&region="+Qt.locale().name.split("_")[1];
        query: "$.results[:15]"
    }

        delegate: Rectangle {
                    width: gview.cellWidth
                    height: gview.iconbasesize
                    color: "transparent"

                    Item {
                        width: units.gu(12)
                        height: units.gu(20)
                            anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            id: imgIcons
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: parent.height
                            source: if(model.poster_path == ""){ "cinema/assets/noposter.png" }else{ "https://image.tmdb.org/t/p/w600_and_h900_bestv2"+model.poster_path }
                            visible: false
                            fillMode: Image.PreserveAspectCrop
                        }

                        UbuntuShape {
                            id: shape
                            source: imgIcons
                            width: parent.width
                            height: parent.height
                            radius : "medium"
                            sourceFillMode: UbuntuShape.PreserveAspectCrop
                        }

                        Rectangle {
                            width: units.gu(12)
                            height: titleMovie.contentHeight
                            color: "#000000"
                            anchors.bottom: imgIcons.bottom
                            opacity: 0.8
                            radius: 8

                            Text{
                                id: titleMovie
                                horizontalAlignment: Text.AlignHCenter
                                width: units.gu(12)
                                wrapMode:Text.WordWrap
                                text: model.title
                                color: "#ffffff"
                            }
                        }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Qt.openUrlExternally( "https://www.themoviedb.org/movie/"+model.id+"-"+model.original_title.replace(' ', '-')+"?language="+Qt.locale().name.split("_")[0] );
                                }
                    } // Item
            }// delegate Rectangle

        }


}//column


}//flickable

}
