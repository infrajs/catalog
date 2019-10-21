{root:}
{:ROWS}
{ROWS:}
<table class="table m-0 w-auto">
{data.list::param}
</table>
{param:}
	<tr class="mb-2">
		<td style="white-space: nowrap;" class="pl-0">{prop}</td>
		<td class="pr-0">{values::opt}</td>
	</tr>
	{opt:}
		<a data-anchor=".table" class="btn mb-1 btn-sm {:is?:stron?:stroff}" 
		href="/catalog{:cat.mark.add}more.{...prop_nick}::.{value_nick}={:is??:str1}">{value}</a>
{is:}{data.md.more[...prop_nick][value_nick]?:yes}
{str1:}1{*:}:more.{...prop_nick}.no=1
{cat::}-catalog/cat.tpl
{stron:}btn-info
{stroff:}btn-outline-secondary