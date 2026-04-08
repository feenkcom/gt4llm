"
Magritte-based tool for changing a class signature (superclass, instance variables, class variables, and package).
"
Class {
	#name : #GtLMagritteToolForClassDefinitionChange,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
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
		builder traitComposition: extractor traitComposition. 
		builder slots: extractor instanceVariables.
		builder classSlots: extractor classInstanceVariables.
		builder sharedVariables: extractor classVariables.
		builder package: extractor packageName.
		builder tag: extractor packageTagName.
		
		extractor targetClass isTrait ifTrue: [ builder beTrait ].
		
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
	^ 'Changes a class signature by updating superclass, instance variables, class variables, package, package tag. 
	
	It also changes a Trait signature by updating instance variables, class instance variables, package, and package tag. In terms of definition, trait is a specialized class, so it have same arguments. It therefore defines trait name using `targetClassName` argument. Trait does not define superclassName, neither `classVariables`.

Example JSON arguments:
{
  "classChangeRequest": {
    "targetClassName": "MyClass",
    "superclassName": "NewSuperclass",
    "traitComposition": "{TMyTrait}",
    "instanceVariables": ["slot1", "slot2"],
    "classInstanceVariables": ["slot3", "slot4"],
    "classVariables": ["SharedValue"],
    "package": "MyPackage",
    "packageTag": "MyTag"
  }
}

Example JSON response:
{
  "currentClassName": "MyClass",
  "superclassName": "NewSuperclass",
  "packageName": "MyPackage",
  "instanceSlotNames": ["slot1", "slot2"],
  "classSlotNames": ["slot3", "slot4"],
  "classVariableNames": ["SharedValue"],
  "traitCompositionString": "{}"
}'
]

{ #category : #testing }
GtLMagritteToolForClassDefinitionChange >> isUsingDataViews [
	^true
]

{ #category : #accessing }
GtLMagritteToolForClassDefinitionChange >> name [
	^ 'changeClassOrTraitSignature'
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChange >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| extractor |
	
	extractor := GtLClassChangeDataExtractor new.
	extractor request: (aToolCall arguments at: 'classChangeRequest').
	
	extractor extractAllIfError: [ :anError | ^ anError ].
	^ self applyClassChangeUsing: extractor
]
