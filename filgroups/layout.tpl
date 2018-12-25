{root:}
{:ROWS}
{ROWS:}
<table class="table m-0 w-auto">
{data.list::param}
</table>
{param:}
	<tr>
		<td style="white-space: nowrap;" class="pt-3">{title}</td>
		<td>{more?option::optmore?option::optmain}</td>
	</tr>
	{optmore:}
		<a data-anchor=".table" class="btn mb-1 btn-sm {:ismore?:stron?:stroff}" 
		href="/catalog{:cat.mark.add}more.{...mdid}::.{id}={:ismore??:str1}">{title}</a>
	{optmain:}
		<a data-anchor=".table" class="btn mb-1 btn-sm {:ismain?:stron?:stroff}" 
		href="/catalog{:cat.mark.add}{...mdid}::.{id}={:ismain??:str1}">{title}</a>
{ismore:}{data.md.more[...mdid][id]?:yes}
{ismain:}{data.md[...mdid][id]?:yes}
{str1:}1
{str2:}1:more.{...mdid}.no=1
{cat::}-catalog/cat.tpl
{stron:}btn-warning
{stroff:}{search?:strsecondary}
{strsecondary:}btn-secondary