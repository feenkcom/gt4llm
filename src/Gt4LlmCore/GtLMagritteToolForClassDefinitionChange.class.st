"
Magritte-based tool for changing a class signature (superclass, instance variables, class variables, and package).
"
Class {
	#name : #GtLMagritteToolForClassDefinitionChange,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #private }
GtLMagritteToolForClassDefinitionChange >> applyClassChangeUsing: changeData [
	| updatedClass originalDescription |
	
	"Capture original state before modifying"
	originalDescription := GtLClassDefinitionDescription 
		fromClass: changeData targetClass.
	
	updatedClass := [
		| builder |
		builder := ShiftClassBuilder new.
		builder fillFor: changeData targetClass.
		builder superclass: changeData superclass.
		builder slots: changeData instanceVariables.
		builder sharedVariables: changeData classVariables.
		builder package: changeData packageName.
		builder install ]
		on: Error
		do: [ :error |
			^ GtLExceptionDomainObject new
				freeze: error;
				description: 'Error while changing class signature';
				yourself ].
	
	^ GtLClassModificationResult new
		originalClass: originalDescription;
		updatedClass: (GtLClassDefinitionDescription fromClass: updatedClass);
		yourself
]

{ #category : #'magritte-description' }
GtLMagritteToolForClassDefinitionChange >> classChangeRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #classChangeRequest;
		classes: { GtLClassChangeRequest };
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForClassDefinitionChange >> description [
	^ 'Changes a class signature by updating superclass, instance variables, class variables, and package.

Example JSON arguments:
{
  "classChangeRequest": {
    "targetClassName": "MyClass",
    "superclassName": "NewSuperclass",
    "instanceVariables": ["slot1", "slot2"],
    "classVariables": ["SharedValue"],
    "package": "MyPackage"
  }
}

Example JSON response:
{
  "currentClassName": "MyClass",
  "superclassName": "NewSuperclass",
  "packageName": "MyPackage",
  "instanceSlotNames": ["slot1", "slot2"],
  "classSlotNames": [],
  "classVariableNames": ["SharedValue"],
  "traitCompositionString": "{}"
}'
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChange >> extractDataInto: changeData ifError: errorBlock [
	self extractTargetClassInto: changeData ifError: errorBlock.
	self extractSuperclassInto: changeData ifError: errorBlock.
	self extractVariablesInto: changeData.
	self extractPackageInto: changeData ifError: errorBlock
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChange >> extractPackageInto: changeData ifError: errorBlock [
	| request packageValue |
	request := changeData request.
	
	packageValue := request package.
	packageValue notNil
		ifTrue: [
			| packageName |
			packageName := packageValue asString trimBoth.
			packageName isEmpty
				ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'package') ].
			changeData packageName: packageName ]
		ifFalse: [ changeData packageName: changeData targetClass package name ]
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChange >> extractSuperclassInto: changeData ifError: errorBlock [
	| request superclassValue |
	request := changeData request.
	
	superclassValue := request superclassName.
	superclassValue notNil
		ifTrue: [
			| superclassName |
			superclassName := superclassValue asString trimBoth.
			superclassName isEmpty
				ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new 
					objectName: 'superclassName') ].
			changeData superclass: (Smalltalk globals
				at: superclassName asSymbol
				ifAbsent: [ ^ errorBlock value: (GtLMissingDomainObject new
					objectName: superclassName) ]) ]
		ifFalse: [
			changeData superclass: changeData targetClass superclass ]
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChange >> extractTargetClassInto: changeData ifError: errorBlock [
	| request classNameValue classNameString |
	request := changeData request.
	
	classNameValue := request targetClassName.
	classNameString := (classNameValue ifNil: [ '' ]) asString trimBoth.
	classNameString isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'targetClassName') ].
	
	changeData targetClass: (Smalltalk globals
		at: classNameString asSymbol
		ifAbsent: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: classNameString) ])
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChange >> extractVariablesInto: changeData [
	| request targetClass |
	request := changeData request.
	targetClass := changeData targetClass.
	
	changeData instanceVariables: (request instanceVariables notEmpty
		ifTrue: [ request instanceVariables collect: [ :each | each asSymbol asSlot ] ]
		ifFalse: [ targetClass localSlots collect: [ :slot | slot copy ] ]).
	
	changeData classVariables: (request classVariables notEmpty
		ifTrue: [ request classVariables collect: [ :each | each asSymbol asClassVariable ] ]
		ifFalse: [ targetClass classVariables collect: [ :var | var copy ] ])
]

{ #category : #accessing }
GtLMagritteToolForClassDefinitionChange >> name [
	^ 'changeClassSignature'
]

{ #category : #actions }
GtLMagritteToolForClassDefinitionChange >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| changeData |
	
	changeData := GtLClassChangeData new.
	changeData request: (aToolCall arguments at: 'classChangeRequest').
	
	self extractDataInto: changeData ifError: [ :anError | ^ anError ].
	^ self applyClassChangeUsing: changeData
]
