## **Cmdlet Reference**

### Invoke-Auspex

This is the main function exposed by the module. It allows you to perform CRUD operations on **Hashtables**, **PSObjects**, **Dictionaries**, and **Lists**, push and pull actions for **objects** and **arrays**.

<small>**Aliases**: <code>ax</code> <code>auspex</code> </small>

**Syntax**

```pre
Invoke-Auspex [-o|ObjectPointer (Object)]
              [-a|Action (String(validateset(read,create,update,delete,push,pull))] 
              [-k|KeyName (String)]
              [-va|Value (Any)]
              [-l|Log (Switch)]
              [-e|EmbeddedName (String)]
```

**Parameters**

| Name       | Type                                  | Description                                                          | Required |
| :--------- | :------------------------------------ | :------------------------------------------------------------------- | :------- |
| **ObjectPointer**   | *PSObject*, *PSCustomObject*, *Hashtable*, *Dictionary*, *SortedList* | The target data structure to modify. | Yes |
| **Action** | *String* | The operation to perform: `create`, `read`, `update`, `delete`, `push`, `pull` | Yes |
| **Name**   | *String* | The property or key name to target. | Yes |
| **Value**  | *Any* | The value to set (for create/update/push) or remove (for pull). Not required for read/delete. | No |
| **log**  | *switch* | Enable logging | No |
| **EmbeddedName**  | *string* | pre-apend a custom name to the log message | No |

> ✴️ ***Note*** !
> ═══════
> These parameters are positionally numbered so you can pass theme in without the **ParameterName** in order.
> eg: 
> `auspex $data create 'Status' 'Active'`
> or: 
> `ax $data create 'Status' 'Active'`
> or: 
> `Invoke-Auspex $data create 'Status' 'Active'`

> ✴️ ***Note*** !
> ═══════
> You can also work with the objects in reverse instead of using the `-KeyName` parameter with dot or array notation or both, you can simply source the object yourself and pass it in as the `-ObjectPointer` parameter. eg: `Invoke-Auspex $data.Network create 'Status' 'Active'`

#### **Examples**

```powershell
Invoke-Auspex $data create 'Status' 'Active'
```


----


## **CMDLET Reference**

List of available cmdlets provided by the module.

#### ***New-CheckSum***

New-CheckSum generates and returns sha256 hash for each within the specified folder. New-Verification unitilizes `New-Checksum` & `Read-CheckSum`.

*Syntax*:

<pre>
New-CheckSum -Path (String) [-FromString (string)] [(CommonParameters)]
</pre>

*Parameters*:

| Name | Type | Description | Required |
| --- | --- | --- | --- |
| **Path** | *String* | The path to generate the checksum file for | Yes |
| **FromString** | *String* | The string to generate the checksum file for | No |

```powershell
New-CheckSum -Path ./
```