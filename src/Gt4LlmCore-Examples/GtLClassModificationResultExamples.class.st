"
Examples for GtLClassModificationResult domain object.
"
Class {
	#name : #GtLClassModificationResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassModificationResultExamples >> classModificationResultCreation [
	<gtExample>
	| result |
	result := GtLClassModificationResult new
		originalClass: self originalClassDefinition;
		updatedClass: self updatedClassDefinition;
		yourself.
	
	"Verify the stored objects"
	self assert: result originalClass isNotNil.
	self assert: result updatedClass isNotNil.
	
	"Verify delegation to updatedClass"
	self assert: result currentClassName equals: 'MyExampleClass'.
	self assert: result superclassName equals: 'Exception'.
	self assert: result packageName equals: 'NewPackage'.
	self assert: result comment equals: 'Updated comment'.
	self assert: result instanceSlotNames equals: #('slot1' 'slot2' 'slot3').
	self assert: result classSlotNames equals: #('classSlot').
	self assert: result classVariableNames equals: #('SharedVar').
	self assert: result traitCompositionString equals: '{}'.
	
	"Verify original is preserved"
	self assert: result originalClass superclassName equals: 'Object'.
	self assert: result originalClass packageName equals: 'OriginalPackage'.
	self assert: result originalClass instanceSlotNames equals: #('slot1').
	
	^ result
]

{ #category : #examples }
GtLClassModificationResultExamples >> classModificationResultFromRealClass [
	<gtExample>
	"Test using a real class from the system"
	| originalDesc updatedDesc result |
	originalDesc := GtLClassDefinitionDescription new initializeFromClass: Boolean.
	updatedDesc := GtLClassDefinitionDescription new
		currentClassName: 'Boolean';
		superclassName: 'Object';
		comment: 'Modified comment';
		packageName: 'Kernel';
		instanceSlotNames: #('newSlot');
		classSlotNames: #();
		classVariableNames: #();
		traitCompositionString: '{}';
		yourself.
	
	result := GtLClassModificationResult new
		originalClass: originalDesc;
		updatedClass: updatedDesc;
		yourself.
	
	"Verify original has real data"
	self assert: result originalClass currentClassName equals: #Boolean.
	self assert: result originalClass superclassName equals: #Object.
	self assert: result originalClass instanceSlotNames isEmpty.
	
	"Verify updated shows the changes"
	self assert: result currentClassName equals: 'Boolean'.
	self assert: result instanceSlotNames equals: #('newSlot').
	self assert: result comment equals: 'Modified comment'.
	
	^ result
]

{ #category : #examples }
GtLClassModificationResultExamples >> classModificationResultSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock expectedJson |
	result := self classModificationResultCreation.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#currentClassName -> 'MyExampleClass'.
		#superclassName -> 'Exception'.
		#packageName -> 'NewPackage'.
		#comment -> 'Updated comment'.
		#instanceSlotNames -> (NeoJSONArray withAll: #('slot1' 'slot2' 'slot3')).
		#classSlotNames -> (NeoJSONArray withAll: #('classSlot')).
		#classVariableNames -> (NeoJSONArray withAll: #('SharedVar')).
		#traitCompositionString -> '{}'
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassModificationResultExamples >> classModificationResultSerializationWithoutOriginal [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	"Verify serialization works when originalClass is nil"
	| result compositeView dataBlock expectedJson |
	result := self classModificationResultWithoutOriginal.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#currentClassName -> 'MyExampleClass'.
		#superclassName -> 'Exception'.
		#packageName -> 'NewPackage'.
		#comment -> 'Updated comment'.
		#instanceSlotNames -> (NeoJSONArray withAll: #('slot1' 'slot2' 'slot3')).
		#classSlotNames -> (NeoJSONArray withAll: #('classSlot')).
		#classVariableNames -> (NeoJSONArray withAll: #('SharedVar')).
		#traitCompositionString -> '{}'
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassModificationResultExamples >> classModificationResultWithoutOriginal [
	<gtExample>
	"Test case where originalClass is nil (e.g., new class creation)"
	| result |
	result := GtLClassModificationResult new
		originalClass: nil;
		updatedClass: self updatedClassDefinition;
		yourself.
	
	self assert: result originalClass isNil.
	self assert: result updatedClass isNotNil.
	
	"Delegation still works"
	self assert: result currentClassName equals: 'MyExampleClass'.
	self assert: result superclassName equals: 'Exception'.
	
	^ result
]

{ #category : #'examples - support' }
GtLClassModificationResultExamples >> originalClassDefinition [
	<gtExample>
	| description |
	description := GtLClassDefinitionDescription new
		currentClassName: 'MyExampleClass';
		superclassName: 'Object';
		comment: 'Original comment';
		packageName: 'OriginalPackage';
		instanceSlotNames: #('slot1');
		classSlotNames: #();
		classVariableNames: #();
		traitCompositionString: '{}';
		yourself.
	self assert: description currentClassName equals: 'MyExampleClass'.
	self assert: description packageName equals: 'OriginalPackage'.
	^ description
]

{ #category : #'examples - support' }
GtLClassModificationResultExamples >> updatedClassDefinition [
	<gtExample>
	| description |
	description := GtLClassDefinitionDescription new
		currentClassName: 'MyExampleClass';
		superclassName: 'Exception';
		comment: 'Updated comment';
		packageName: 'NewPackage';
		instanceSlotNames: #('slot1' 'slot2' 'slot3');
		classSlotNames: #('classSlot');
		classVariableNames: #('SharedVar');
		traitCompositionString: '{}';
		yourself.
	self assert: description currentClassName equals: 'MyExampleClass'.
	self assert: description superclassName equals: 'Exception'.
	self assert: description packageName equals: 'NewPackage'.
	self assert: description instanceSlotNames equals: #('slot1' 'slot2' 'slot3').
	^ description
]
