import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: qsTr("MyGoGame")
    id: main_page
    width: 30*size
    height: 30*size + 30 + 20
    visible: true
    //flags: Qt.FramelessWindowHint
    //modality: Qt.WindowModal


    //property int bombs: 10
    property int size: 8
    property int i_n: 0
    property int j: 0
    property int q: 0
    property int k : 0
    property int field_full: 0

    property int active_player: 1

    property var settings_page: null

    property int making: 0

    property string cll_text: ""

    signal check_cell_now(int ind, int filling)
    signal go_new()
    signal setConnection()


    function set_st(index, sta)
    {
        sap_grid.set(index, {"st": sta})
    }

    function find_same(index, naprav, sta)
    {
        var j
        switch(naprav)
        {
        case 1:
            j = index - size
            while(j >= 0)
            {
                if(sap_grid.get(j).st === sta)
                    return 1
                else if(sap_grid.get(j).st === "st1" || sap_grid.get(j).st === "st5")
                    return 0
                j-=size
            }
            break
        case 2:
            j = index+1
            if(j % size === 0)
                return 0
            while(j < index + size - index%size)
            {
                if(sap_grid.get(j).st === sta)
                    return 1
                else if(sap_grid.get(j).st === "st1" || sap_grid.get(j).st === "st5")
                    return 0
                j+=1
            }
            break
        case 3:
            j = index+size
            while(j < size*size)
            {
                if(sap_grid.get(j).st === sta)
                    return 1
                else if(sap_grid.get(j).st === "st1" || sap_grid.get(j).st === "st5")
                    return 0
                j+=size
            }
            break
        case 4:
            j = index-1
            while(j >= index - index%size)
            {
                if(sap_grid.get(j).st === sta)
                    return 1
                else if(sap_grid.get(j).st === "st1" || sap_grid.get(j).st === "st5")
                    return 0
                j-=1
            }
            break
        }
        return 0
    }

    function check_other_cells(index, activep)
    {
        var i
        //вверх
        i = index - size
        while(i >= 0)
        {
            if(activep === 1 && find_same(index, 1, "st2") === 1)
            {
                if(sap_grid.get(i).st === "st3")
                    set_st(i, "st2")
                else
                    break
            }
            else if(activep === 2 && find_same(index, 1, "st3") === 1)
            {
                if(sap_grid.get(i).st === "st2")
                    set_st(i, "st3")
                else
                    break
            }
            i-=size
        }

        //вниз
        i = index+size
        while(i < size*size)
        {
            if(activep === 1 && find_same(index, 3, "st2") === 1)
            {
                if(sap_grid.get(i).st === "st3")
                    set_st(i, "st2")
                else
                    break
            }
            else if(activep === 2 && find_same(index, 3, "st3") === 1)
            {
                if(sap_grid.get(i).st === "st2")
                    set_st(i, "st3")
                else
                    break
            }
            i+=size
        }
        //влево
        i = index-1
        while(i >= index - index%size)
        {
            if(activep === 1 && find_same(index, 4, "st2") === 1)
            {
                if(sap_grid.get(i).st === "st3")
                    set_st(i, "st2")
                else
                    break
            }
            else if(activep === 2 && find_same(index, 4, "st3") === 1)
            {
                if(sap_grid.get(i).st === "st2")
                    set_st(i, "st3")
                else
                    break
            }
            i-=1
        }
        //вправо
        i = index+1
        while(i < index + size - index%size)
        {
            if(activep === 1 && find_same(index, 2, "st2") === 1)
            {
                if(sap_grid.get(i).st === "st3")
                    set_st(i, "st2")
                else
                    break
            }
            else if(activep === 2 && find_same(index, 2, "st3") === 1)
            {
                if(sap_grid.get(i).st === "st2")
                    set_st(i, "st3")
                else
                    break
            }
            i+=1
        }
    }

    function start_new()
    {
        main_grid.enabled = true
        go_new()
        main_rec.focus = true
    }

    function on_hover_cell(a, st)
    {
        switch(st){
        case 0:
            sap_grid.set(a, {"st": "st1"})
            break
        case 1:
            sap_grid.set(a, {"st": "st5"})
            break
        }
    }

    function on_set_size(num)
    {
        sap_grid.clear()
        size = num
        for(q = 0; q < size*size; q++)
        {
            sap_grid.append({"a": q, "st":"st1" , "t":""})
        }

    }

    property int pre_x: 0
    property int pre_y: 0

    menuBar: MenuBar {
        Menu {
            title: qsTr("&Game")
            MenuItem {
                text: qsTr("&New game")
                onTriggered: start_new()
            }
            MenuItem {
                text: qsTr("&Подключиться")
                onTriggered: setConnection()
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    MouseArea{
        id: allArea
        anchors.fill: parent
        onPressed: {
            pre_x = mouseX
            pre_y = mouseY
        }
        onMouseXChanged: {
            var dx = mouseX - pre_x
            main_page.setX(main_page.x + dx)
        }
        onMouseYChanged: {
            var dy = mouseY - pre_y
            main_page.setY(main_page.y + dy)
        }
    }

    Rectangle{
        id:main_rec
        anchors.fill: parent
        color: "transparent"
        focus: true


        ListModel{
            id: sap_grid
            dynamicRoles : false
        }

        Component{
            id: sap_cell
            Item{
                id: it
                width: main_grid.cellWidth; height: main_grid.cellHeight
                state: st
                states:[State{name: "st1"},State{name: "st2"},State{name: "st3"},State{name: "st5"}]
                Rectangle
                {
                    id: recc
                    width: main_grid.cellWidth; height: main_grid.cellHeight;
                    color: "#bbbbbb"
                    border.color: "#000000";
                    border.width: 1
                    radius: 4
                    opacity: it.state === "st5" ? 0.6 : 1
                    Rectangle{
                        id: roundrec
                        anchors.centerIn: parent
                        radius: 10
                        width: parent.width/3*2
                        height: parent.height/3*2
                        color: (st === "st2") ? "#000000" : ((st === "st3") ? "#ffffff"
                                          : ((st === "st5") ? "transparent" : "transparent"));
                    }
//                    Text{
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        anchors.top: parent.top
//                        text: st
//                    }
//                    Text{
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        anchors.bottom: parent.bottom
//                        text: a
//                    }
                    MouseArea{
                        anchors.fill: parent;
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        onClicked:
                        {
                            if (mouse.button == Qt.RightButton)
                            {

                            }
                            else
                            {
                                if(it.state === "st5" || it.state === "st1")
                                {
                                    if(active_player == 1)
                                    {
                                        it.state = "st2"
                                        active_player = 2
                                        set_st(a, "st2")
                                        check_other_cells(a, 1)
                                    }
                                    else
                                    {
                                        it.state = "st3"
                                        active_player = 1
                                        set_st(a, "st3")
                                        check_other_cells(a, 2)
                                    }
                                }
                            }
                        }
                        onHoveredChanged: {
                            if(it.state === "st1")
                            {
                                on_hover_cell(a, 1)
                            }
                            else if(it.state === "st5")
                            {
                                on_hover_cell(a, 0)
                            }
                        }
                    }
                }
            }
        }

        GridView{
            id: main_grid
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height * 30*(size) / (30*(size +1))
            cellWidth: parent.width/size ;
            cellHeight: height / size
            model: sap_grid
            delegate: sap_cell
        }
        Rectangle{
            id: topper
            anchors.top: parent.top
            width: parent.width
            border.color: "#000000"
            border.width: 1
            state: "st1"
            height: 30
            Rectangle{
                id: rt1
                width: parent.width/2
                height: parent.height
                anchors.left: parent.left
                border.color: "#000000"
                border.width: 1
                state: active_player == 1 ? "st1" : "st2"
                states:[State{name: "st1"},State{name: "st2"}]
                color: state=="st1" ? "#00ff00" : "#cccccc"
                TextEdit{
                    anchors.centerIn: parent
                    text: "1"
                }
            }
            Rectangle{
                id: rt2
                width: parent.width/2
                height: parent.height
                anchors.right: parent.right
                border.color: "#000000"
                border.width: 1
                state: active_player == 2 ? "st1" : "st2"
                states:[State{name: "st1"},State{name: "st2"}]
                color: state=="st1" ? "#00ff00" : "#cccccc"
                TextEdit{
                    anchors.centerIn: parent
                    text: "2"
                }
            }
        }
    }
}
