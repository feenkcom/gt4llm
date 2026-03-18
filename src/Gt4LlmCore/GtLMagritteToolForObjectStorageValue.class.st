"
Magritte-based tool for retrieving an object from the object storage and returning its serialized value.
"
Class {
	#name : #GtLMagritteToolForObjectStorageValue,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMagritteToolForObjectStorageValue >> description [
	^ 'Retrieves an object from the object storage and returns its serialized value, equivalent to inspecting it in the Smalltalk code evaluation tool.'
]

{ #category : #accessing }
GtLMagritteToolForObjectStorageValue >> name [
	^ 'getObjectStorageValue'
]

{ #category : #descriptions }
GtLMagritteToolForObjectStorageValue >> objectIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Object id';
		accessor: #objectId;
		beRequired
]

{ #category : #private }
GtLMagritteToolForObjectStorageValue >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments objectId object |
	arguments := aToolCall arguments.
	objectId := arguments at: 'objectId'.
	(objectId isNil or: [ objectId isString and: [ objectId trimBoth isEmpty ] ]) ifTrue: [
		^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'objectId' ].
	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new
			missingModelName: 'objectStorage' ].
	object := anExecutionContext objectStorage
		objectAt: objectId
		ifPresent: [ :storedObject | storedObject ]
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: objectId ].
	^ GtLObjectStorageValueResult new
		object: object;
		objectValue: (GtLSerializedObjectValue fromObject: object);
		objectId: objectId
]
