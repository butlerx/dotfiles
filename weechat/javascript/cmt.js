weechat.register("RedbrickCmt", "butlerx", "1.0", "GPL3", "Redbrick Committee script", "", "");
weechat.hook_command("cmt", "printcmt", "", "", "", "loadCmt", "");

async function loadCmt () {
  const request = new XMLHttpRequest();
  request.open('GET', 'https://www.redbrick.dcu.ie/api/committee', true );
  request.onreadystatechange = () => {
    if(request.readyState === XMLHttpRequest.DONE && request.status === 200) {
      const cmt = JSON.parse(request.responseText);
      let list = '';
      await cmt.forEach(({nick}) => { list += `${nick}, ` });
      return list
    }
  };
  request.send();
}

function print () {
  weechat.prnt(weechat.current_buffer(), loadCmt);
}
