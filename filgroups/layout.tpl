{root:}
{:ROWS}
{ROWS:}
<table class="table m-0 w-auto">
{data.list::param}
</table>
{param:}
	<tr class="mb-2">
		<td style="white-space: nowrap;" class="pl-0">{prop}</td>
		<td class="pr-0">{more?options::optmore?options::optmain}</td>
	</tr>
	{optmore:}
		<a data-anchor=".table" class="btn mb-1 btn-sm {:ismore?:stron?:stroff}" 
		href="/catalog{:cat.mark.add}more.{...prop_nick}::.{value_nick}={:ismore??:str1}">{value}</a>
	{optmain:}
		<a data-anchor=".table" class="btn mb-1 btn-sm {:ismain?:stron?:stroff}" 
		href="/catalog{:cat.mark.add}{...prop_nick}::.{value_nick}={:ismain??:str1}">{value}</a>
{ismore:}{data.md.more[...prop_nick][value_nick]?:yes}
{ismain:}{data.md[...prop_nick][value_nick]?:yes}
{str1:}1
{str2:}1:more.{...prop_nick}.no=1
{cat::}-catalog/cat.tpl
{stron:}btn-warning
{stroff:}{:strsecondary}
{strsecondary:}btn-secondary