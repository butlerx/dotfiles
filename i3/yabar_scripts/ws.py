import i3ipc

i3 = i3ipc.Connection()

def print_workspaces():
    workspaces = i3.get_workspaces()
    outputlist=[]
    for i in workspaces:
        underline = ""
        ucolor = ""
        bgcolor = ""
        if i['focused']:
            underline = " underline=\"single\" "
            ucolor = " underline_color=\"#cccccc\" "
        if i['visible']:
            bgcolor = " bgcolor=\"#5ba7c3\" "
        if i['urgent']:
            bgcolor = " bgcolor=\"#cc0000\" "
            underline = " underline=\"single\" "
            ucolor = " underline_color=\"#cccccc\" "
        output =  "<span" + bgcolor + underline +  ucolor  + ">  " + i['name'] + "  </span>"
        outputlist.append(output)
    print("".join(outputlist))

print_workspaces()

def list_workspaces(event, data, subscription):
    if 'change' in event:
        print_workspaces()
