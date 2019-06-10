
{client.set:}{Crumb.get.m?:client}
{client.aset:}{Crumb.get.m?:aclient}
{client.add:}{:client}:
    {client:}?m={Crumb.get.m}
    {aclient:}&amp;m={Crumb.get.m}
{server.set:}{data.m?:server}
{server.add:}{:server}:
    {server:}?m={data.m}
    {aserver:}&amp;m={data.m}
{set:}{data.m?:server}
{aset:}{data.m?:aserver}
{add:}{:server}: