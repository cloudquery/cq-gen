package tests

type BaseStruct struct {
	IntValue  int
	BoolValue bool
	Embedded  EmbeddedStruct
}

type EmbeddedStruct struct {
	FieldA int
}

// ComplexStruct written descriptions on structs are show as descriptions in the table
type ComplexStruct struct {
	IntValue    int
	Int8Value   int8
	Int16Value  int16
	Int32Value  int32
	Int64Value  int64
	String      string
	StringArray []string
	BoolValue   bool
	// Comments written as descriptions on fields are show as descriptions
	Json map[string]interface{}
}
