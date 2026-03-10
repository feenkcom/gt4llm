"
Magritte-based tool for creating a single class.
"
Class {
	#name : #GtLMagritteToolForClassCreation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForClassCreation >> classCreationRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #classCreationRequest;
		classes: { GtLClassCreationRequest };
		beRequired
]

{ #category : #private }
GtLMagritteToolForClassCreation >> createClassFromRequest: aRequest [
	"Create a class from a request. Returns a GtLClassModificationResult or an error domain object.
	This method is reused by GtLMagritteToolForClassesCreation."
	| extractor |
	
	extractor := GtLClassCreationDataExtractor new.
	extractor request: aRequest.
	
	extractor extractAllIfError: [ :anError | ^ anError ].
	^ self createClassUsing: extractor ifError: [ :anError | ^ anError ]
]

{ #category : #'private - creation' }
GtLMagritteToolForClassCreation >> createClassUsing: extractor ifError: errorBlock [
	| createdClass |
	
	createdClass := [ extractor superclass classInstaller
		make: [ :builder |
			builder
				superclass: extractor superclass;
				name: extractor targetClassName;
				slots: extractor instanceVariables;
				sharedVariables: extractor classVariables;
				traitComposition: extractor traitComposition;
				package: extractor packageName;
				comment: extractor comment;
				environment: extractor superclass environment ] ]
		on: Error
		do: [ :error |
			^ errorBlock value: (GtLCouldNotCreateClassDomainObject new
				superclass: extractor superclass;
				targetClassName: extractor targetClassName;
				packageName: extractor packageName;
				instanceVariableNames: (extractor instanceVariables collect: #name) asArray;
				classVariableNames: (extractor classVariables collect: #name) asArray;
				freeze: error) ].
	
	^ GtLClassModificationResult new
		originalClass: nil;
		updatedClass: (GtLClassDefinitionDescription fromClass: createdClass);
		yourself
]

{ #category : #accessing }
GtLMagritteToolForClassCreation >> description [
	^ 'Creates a single class with the provided superclass, variables, traits, and package.

Example JSON arguments:
{
  "classCreationRequest": {
    "targetClassName": "MyClass",
    "superclassName": "Object",
    "package": "MyPackage",
    "instanceVariables": "slot1 slot2",
    "classVariables": "SharedValue",
    "traitCompositionString": "{}",
    "comment": "A description of the class"
  }
}

Example JSON response:
{
  "currentClassName": "MyClass",
  "superclassName": "Object",
  "packageName": "MyPackage",
  "instanceSlotNames": ["slot1", "slot2"],
  "classSlotNames": [],
  "classVariableNames": ["SharedValue"],
  "traitCompositionString": "{}",
  "comment": "A description of the class"
}'
]

{ #category : #accessing }
GtLMagritteToolForClassCreation >> name [
	^ 'createClass'
]

{ #category : #private }
GtLMagritteToolForClassCreation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| request |
	request := aToolCall arguments at: 'classCreationRequest'.
	^ self createClassFromRequest: request
]
