"
Examples for GtLClassesCreationResult domain object.
"
Class {
	#name : #GtLClassesCreationResultExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'examples - support' }
GtLClassesCreationResultExamples >> anotherClassModificationResult [
	<gtExample>
	| result |
	result := GtLClassModificationResult new
		originalClass: nil;
		updatedClass: (GtLClassDefinitionDescription new
			currentClassName: 'AnotherCreatedClass';
			superclassName: 'Exception';
			comment: 'Another sample class';
			packageName: 'SamplePackage';
			instanceSlotNames: #('value' 'count');
			classSlotNames: #();
			classVariableNames: #();
			traitCompositionString: '{}';
			yourself);
		yourself.
	self assert: result currentClassName equals: 'AnotherCreatedClass'.
	^ result
]

{ #category : #'examples - serialization' }
GtLClassesCreationResultExamples >> creationResultSerializationWithMixedResults [
	<gtExample>
	| result json classesJson |
	result := self creationResultWithMixedResults.
	
	json := GtMagritteJSONDataExporter exportObject: result.
	
	self assert: (json includesKey: 'classes').
	classesJson := json at: 'classes'.
	self assert: classesJson size equals: 4.
	
	"First element: successful class"
	self assert: (classesJson first at: 'currentClassName') equals: 'SampleCreatedClass'.
	
	"Second element: missing domain object error"
	self assert: (classesJson second at: 'missingObjectName') equals: 'UnknownSuperclass'.
	
	"Third element: another successful class"
	self assert: (classesJson third at: 'currentClassName') equals: 'AnotherCreatedClass'.
	
	"Fourth element: could not create class error"
	self assert: (classesJson fourth at: 'targetClassName') equals: 'FailedClass'.
	self assert: (classesJson fourth at: 'packageName') equals: 'TestPackage'.
	
	^ json
]

{ #category : #'examples - serialization' }
GtLClassesCreationResultExamples >> creationResultSerializationWithMultipleClasses [
	<gtExample>
	| result json classesJson |
	result := self creationResultWithMultipleClasses.
	
	json := GtMagritteJSONDataExporter exportObject: result.
	
	self assert: (json includesKey: 'classes').
	classesJson := json at: 'classes'.
	self assert: classesJson size equals: 2.
	
	"Verify first class"
	self assert: (classesJson first at: 'currentClassName') equals: 'SampleCreatedClass'.
	self assert: (classesJson first at: 'superclassName') equals: 'Object'.
	
	"Verify second class"
	self assert: (classesJson second at: 'currentClassName') equals: 'AnotherCreatedClass'.
	self assert: (classesJson second at: 'superclassName') equals: 'Exception'.
	
	^ json
]

{ #category : #'examples - serialization' }
GtLClassesCreationResultExamples >> creationResultSerializationWithSingleClass [
	<gtExample>
	| result json classesJson |
	result := self creationResultWithSingleClass.
	
	json := GtMagritteJSONDataExporter exportObject: result.
	
	self assert: (json includesKey: 'classes').
	classesJson := json at: 'classes'.
	self assert: classesJson size equals: 1.
	
	"Verify the nested class is serialized with its properties"
	self assert: (classesJson first at: 'currentClassName') equals: 'SampleCreatedClass'.
	self assert: (classesJson first at: 'superclassName') equals: 'Object'.
	self assert: (classesJson first at: 'packageName') equals: 'SamplePackage'.
	
	^ json
]

{ #category : #examples }
GtLClassesCreationResultExamples >> creationResultWithMixedResults [
	<gtExample>
	"Tests a result containing both successes and errors"
	| result |
	result := GtLClassesCreationResult new
		classes: { 
			self sampleClassModificationResult.
			self sampleMissingDomainObject.
			self anotherClassModificationResult.
			self sampleCouldNotCreateClassObject };
		yourself.
	
	self assert: result classes size equals: 4.
	
	"Verify successes"
	self assert: (result classes first isKindOf: GtLClassModificationResult).
	self assert: (result classes third isKindOf: GtLClassModificationResult).
	
	"Verify errors"
	self assert: result classes second isErrorDomainObject.
	self assert: result classes fourth isErrorDomainObject.
	
	^ result
]

{ #category : #examples }
GtLClassesCreationResultExamples >> creationResultWithMultipleClasses [
	<gtExample>
	| result |
	result := GtLClassesCreationResult new
		classes: { 
			self sampleClassModificationResult.
			self anotherClassModificationResult };
		yourself.
	
	self assert: result classes size equals: 2.
	self assert: result classes first currentClassName equals: 'SampleCreatedClass'.
	self assert: result classes second currentClassName equals: 'AnotherCreatedClass'.
	
	^ result
]

{ #category : #examples }
GtLClassesCreationResultExamples >> creationResultWithSingleClass [
	<gtExample>
	| result |
	result := GtLClassesCreationResult new
		classes: { self sampleClassModificationResult };
		yourself.
	
	self assert: result classes size equals: 1.
	self assert: result classes first currentClassName equals: 'SampleCreatedClass'.
	
	^ result
]

{ #category : #examples }
GtLClassesCreationResultExamples >> emptyCreationResult [
	<gtExample>
	| result |
	result := GtLClassesCreationResult new.
	
	self assert: result classes isEmpty.
	self assert: result classes equals: #().
	
	^ result
]

{ #category : #'examples - serialization' }
GtLClassesCreationResultExamples >> emptyCreationResultSerialization [
	<gtExample>
	| result json |
	result := self emptyCreationResult.
	
	json := GtMagritteJSONDataExporter exportObject: result.
	
	self assert: (json includesKey: 'classes').
	self assert: (json at: 'classes') isEmpty.
	
	^ json
]

{ #category : #'examples - support' }
GtLClassesCreationResultExamples >> sampleClassModificationResult [
	<gtExample>
	| result |
	result := GtLClassModificationResult new
		originalClass: nil;
		updatedClass: (GtLClassDefinitionDescription new
			currentClassName: 'SampleCreatedClass';
			superclassName: 'Object';
			comment: 'A sample class';
			packageName: 'SamplePackage';
			instanceSlotNames: #('slot1');
			classSlotNames: #();
			classVariableNames: #();
			traitCompositionString: '{}';
			yourself);
		yourself.
	self assert: result currentClassName equals: 'SampleCreatedClass'.
	^ result
]

{ #category : #'examples - support' }
GtLClassesCreationResultExamples >> sampleCouldNotCreateClassObject [
	<gtExample>
	| obj |
	obj := GtLCouldNotCreateClassDomainObject new
		targetClassName: 'FailedClass';
		packageName: 'TestPackage';
		yourself.
	self assert: obj targetClassName equals: 'FailedClass'.
	self assert: obj packageName equals: 'TestPackage'.
	^ obj
]

{ #category : #'examples - support' }
GtLClassesCreationResultExamples >> sampleMissingDomainObject [
	<gtExample>
	| obj |
	obj := GtLMissingDomainObject new
		objectName: 'UnknownSuperclass';
		yourself.
	self assert: obj objectName equals: 'UnknownSuperclass'.
	^ obj
]
