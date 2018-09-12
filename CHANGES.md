Adds a new setting to allow finer-grained control over which `marc4j` reader
is used to process binary MARC. 

`traject` uses a broadly permissive set of defaults to read binary MARC
records, which may not always be what you want.  The `permissive` setting sets
the flag of the same name on the
(https://github.com/marc4j/marc4j/blob/master/src/org/marc4j/MarcPermissiveStreamReader.java#L164)['permissive'
reader class] provided by marc4j (which, at the time of writing, controls how
that reader guesses the encoding of input records.

## Use the "strict" `org.marc4j.MarcStreamReader` class to read MARC21

In situations where you want stricter record processing -- or in case your records can't be processed by the permissive stream reader (paradoxically, `MarcStreamReader` is more forgiving of certain non-standard MARC, e.g. uppercase subfields), you can specify that `traject` should use the `org.marc4j.MarcStreamReader` class:

```ruby 
settings do 
    provide 'marc4j_reader.class', 'MarcStreamReader'
end
```

## A note about `permissive`

The `marc4j_reader.permissive` setting, which previously existed, is passed
through to the constructor of the `MarcPermissiveStreamReader` class, and does
not effect which class is used to read MARC21 input.  If you set both this parameter and the `marc4j_reader.class` parameter, the `permissive` setting will be ignored.


