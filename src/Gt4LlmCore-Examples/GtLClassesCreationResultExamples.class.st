"
Examples for GtLClassesCreationResult domain object.
"
Class {
	#name : #GtLClassesCreationResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
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
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock jsonData classesJson |
	result := self creationResultWithMixedResults.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData includesKey: #classes).
	classesJson := jsonData at: #classes.
	self assert: classesJson size equals: 4.
	
	"First element: successful class"
	self assert: (classesJson first at: #currentClassName) equals: 'SampleCreatedClass'.
	self assert: (classesJson first at: #superclassName) equals: 'Object'.
	self assert: (classesJson first at: #packageName) equals: 'SamplePackage'.
	
	"Second element: missing domain object error"
	self assert: (classesJson second at: #missingObjectName) equals: 'UnknownSuperclass'.
	self assert: (classesJson second at: #errorMessage) equals: 'UnknownSuperclass is not found'.
	
	"Third element: another successful class"
	self assert: (classesJson third at: #currentClassName) equals: 'AnotherCreatedClass'.
	self assert: (classesJson third at: #superclassName) equals: 'Exception'.
	
	"Fourth element: could not create class error"
	self assert: (classesJson fourth at: #targetClassName) equals: 'FailedClass'.
	self assert: (classesJson fourth at: #packageName) equals: 'TestPackage'.
	self assert: (classesJson fourth at: #messageText) equals: 'Class creation error: unknown error'.
	
	^ dataBlock
]

{ #category : #'examples - serialization' }
GtLClassesCreationResultExamples >> creationResultSerializationWithMultipleClasses [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock jsonData firstClassJson secondClassJson expectedJson |
	result := self creationResultWithMultipleClasses.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	
	firstClassJson := NeoJSONObject new
		at: #currentClassName put: 'SampleCreatedClass';
		at: #superclassName put: 'Object';
		at: #packageName put: 'SamplePackage';
		at: #comment put: 'A sample class';
		at: #instanceSlotNames put: (NeoJSONArray withAll: #('slot1'));
		at: #classSlotNames put: NeoJSONArray new;
		at: #classVariableNames put: NeoJSONArray new;
		at: #traitCompositionString put: '{}';
		yourself.
	secondClassJson := NeoJSONObject new
		at: #currentClassName put: 'AnotherCreatedClass';
		at: #superclassName put: 'Exception';
		at: #packageName put: 'SamplePackage';
		at: #comment put: 'Another sample class';
		at: #instanceSlotNames put: (NeoJSONArray withAll: #('value' 'count'));
		at: #classSlotNames put: NeoJSONArray new;
		at: #classVariableNames put: NeoJSONArray new;
		at: #traitCompositionString put: '{}';
		yourself.
	expectedJson := {
		#classes -> (NeoJSONArray with: firstClassJson with: secondClassJson)
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]

{ #category : #'examples - serialization' }
GtLClassesCreationResultExamples >> creationResultSerializationWithSingleClass [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock jsonData expectedClassJson expectedJson |
	result := self creationResultWithSingleClass.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	
	expectedClassJson := NeoJSONObject new
		at: #currentClassName put: 'SampleCreatedClass';
		at: #superclassName put: 'Object';
		at: #packageName put: 'SamplePackage';
		at: #comment put: 'A sample class';
		at: #instanceSlotNames put: (NeoJSONArray withAll: #('slot1'));
		at: #classSlotNames put: NeoJSONArray new;
		at: #classVariableNames put: NeoJSONArray new;
		at: #traitCompositionString put: '{}';
		yourself.
	expectedJson := {
		#classes -> (NeoJSONArray with: expectedClassJson)
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
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
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock jsonData expectedJson |
	result := self emptyCreationResult.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#classes -> NeoJSONArray new
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
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
