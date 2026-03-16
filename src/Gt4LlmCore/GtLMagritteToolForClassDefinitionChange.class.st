"
Magritte-based tool for changing a class signature (superclass, instance variables, class variables, and package).
"
Class {
	#name : #GtLMagritteToolForClassDefinitionChange,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #'private - change' }
GtLMagritteToolForClassDefinitionChange >> applyClassChangeUsing: extractor [
	| updatedClass originalDescription |
	
	"Capture original state before modifying"
	originalDescription := GtLClassDefinitionDescription 
		fromClass: extractor targetClass.
	
	updatedClass := [
		| builder |
		builder := ShiftClassBuilder new.
		builder fillFor: extractor targetClass.
		builder superclass: extractor superclass.
		builder slots: extractor instanceVariables.
		builder sharedVariables: extractor classVariables.
		builder package: extractor packageName.
		builder install ]
		on: Error
		do: [ :error |
			^ (GtLExceptionDomainObject freeze: error)
					errorReason: 'Error while changing class signature' ].
	
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

{ #category : #accessing }
GtLMagritteToolForClassDefinitionChange >> name [
	^ 'changeClassSignature'
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChange >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| extractor |
	
	extractor := GtLClassChangeDataExtractor new.
	extractor request: (aToolCall arguments at: 'classChangeRequest').
	
	extractor extractAllIfError: [ :anError | ^ anError ].
	^ self applyClassChangeUsing: extractor
]
