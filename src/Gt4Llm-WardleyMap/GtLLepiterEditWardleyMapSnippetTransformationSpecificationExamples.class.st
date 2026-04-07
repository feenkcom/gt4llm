Class {
	#name : #GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> addEdge [
	<gtExample>
	| map spec previous node2 edge node1 |
	previous := self addNode.
	map := previous wardleyMap.
	spec := GtLLepiterEditWardleyMapSnippetTransformationSpecification new.
	spec
		wardleyMap: map;
		changes: {GtWardleyMapAddNodeChangeSpecification new
					nodeId: self node2Id;
					label: 'Node2';
					evolution: 0.375;
					visibility: 0.5.
				GtWardleyMapAddEdgeChangeSpecification new
					fromNodeId: self node1Id;
					toNodeId: self node2Id;
					label: 'Edge'}.
	spec changeObject execute.
	self assert: map nodes size equals: 2.
	self assert: map edges size equals: 1.
	self assert: map notes size equals: 0.
	node1 := map nodes first.
	node2 := map nodes last.
	self assert: node2 id ~= (UUID gtFromString: self node2Id).
	self assert: node2 label equals: 'Node2'.
	self assert: node2 evolution equals: 0.375.
	self assert: node2 visibility equals: 0.5.
	edge := map edges first.
	self assert: edge label equals: 'Edge'.
	self assert: edge fromNode equals: node1.
	self assert: edge toNode equals: node2.
	^ spec
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> addEdgeProposedModificationsPreview [
	<gtExample>
	| map spec preview |
	spec := self addEdge.
	map := spec wardleyMap.
	preview := spec proposedModificationsInPreview.
	self assert: preview nodes size equals: map nodes size.
	self assert: preview edges size equals: map edges size.
	self assert: preview notes size equals: map notes size.
	self assert: preview nodes first wardleyMapDecoratorModels size equals: 0.
	self assert: preview nodes last wardleyMapDecoratorModels size equals: 1.
	self assert: preview edges first wardleyMapDecoratorModels size equals: 1.
	^ preview
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> addNode [
	<gtExample>
	| map spec node1 |
	map := GtWardleyMapModel new.
	spec := GtLLepiterEditWardleyMapSnippetTransformationSpecification new.
	spec
		wardleyMap: map;
		changes: {GtWardleyMapAddNodeChangeSpecification new
					nodeId: self node1Id;
					label: 'Node1';
					evolution: 0.125;
					visibility: 0.25}.
	spec changeObject execute.
	self assert: map nodes size equals: 1.
	self assert: map edges size equals: 0.
	self assert: map notes size equals: 0.
	node1 := map nodes first.
	self assert: node1 id ~= (UUID gtFromString: self node1Id).
	self assert: node1 label equals: 'Node1'.
	self assert: node1 evolution equals: 0.125.
	self assert: node1 visibility equals: 0.25.
	^ spec
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> addNodeProposedModificationsPreview [
	<gtExample>
	| map spec preview |
	spec := self addNode.
	map := spec wardleyMap.
	preview := spec proposedModificationsInPreview.
	self assert: preview nodes size equals: map nodes size.
	self assert: preview edges size equals: map edges size.
	self assert: preview notes size equals: map notes size.
	self assert: preview nodes first wardleyMapDecoratorModels size equals: 1.
	^ preview
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> addNote [
	<gtExample>
	| map spec previous note |
	previous := self addNode.
	map := previous wardleyMap.
	spec := GtLLepiterEditWardleyMapSnippetTransformationSpecification new.
	spec
		wardleyMap: map;
		changes: {GtWardleyMapAddNoteChangeSpecification new
					noteId: self noteId;
					label: 'Some note';
					evolution: 0.5;
					visibility: 0.75}.
	spec changeObject execute.
	self assert: map nodes size equals: 1.
	self assert: map edges size equals: 0.
	self assert: map notes size equals: 1.
	note := map notes first.
	self assert: note label equals: 'Some note'.
	self assert: note evolution equals: 0.5.
	self assert: note visibility equals: 0.75.
	^ spec
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> addNoteProposedModificationsPreview [
	<gtExample>
	| map spec preview |
	spec := self addNote.
	map := spec wardleyMap.
	preview := spec proposedModificationsInPreview.
	self assert: preview nodes size equals: map nodes size.
	self assert: preview edges size equals: map edges size.
	self assert: preview notes size equals: map notes size.
	self assert: preview notes first wardleyMapDecoratorModels size equals: 1.
	^ preview
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> node1Id [
	^ String new: 24 withAll: $1
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> node2Id [
	^ '11111111-2222-3333-4444-555555555555'
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> noteId [
	^ String new: 26 withAll: $9
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> removeEdge [
	<gtExample>
	| map spec previous |
	previous := self updateEdgeAndNodes.
	map := previous wardleyMap.
	spec := GtLLepiterEditWardleyMapSnippetTransformationSpecification new.
	spec
		wardleyMap: map;
		changes: {GtWardleyMapRemoveEdgeSpecification new
					fromNodeId: self node1Id;
					toNodeId: self node2Id}.
	spec changeObject execute.
	self assert: map nodes size equals: 2.
	self assert: map edges size equals: 0.
	^ spec
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> removeEdgeProposedModificationsPreview [
	<gtExample>
	| map spec preview |
	spec := self removeEdge.
	map := spec wardleyMap.
	preview := spec proposedModificationsInPreview.
	self assert: preview edges first wardleyMapDecoratorModels size equals: 1.
	^ preview
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> removeNode [
	<gtExample>
	| map spec previous |
	previous := self removeEdge.
	map := previous wardleyMap.
	spec := GtLLepiterEditWardleyMapSnippetTransformationSpecification new.
	spec
		wardleyMap: map;
		changes: {GtWardleyMapRemoveNodeChangeSpecification new nodeId: self node1Id}.
	spec changeObject execute.
	self assert: map nodes size equals: 1.
	self assert: map edges size equals: 0.
	^ spec
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> removeNodeProposedModificationsPreview [
	<gtExample>
	| map spec preview |
	spec := self removeNode.
	map := spec wardleyMap.
	preview := spec proposedModificationsInPreview.
	self assert: preview nodes first wardleyMapDecoratorModels size equals: 1.
	^ preview
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> removeNote [
	<gtExample>
	| map spec previous |
	previous := self updateNote.
	map := previous wardleyMap.
	spec := GtLLepiterEditWardleyMapSnippetTransformationSpecification new.
	spec
		wardleyMap: map;
		changes: {GtWardleyMapRemoveNoteChangeSpecification new noteId: self noteId}.
	spec changeObject execute.
	self assert: map notes isEmpty.
	^ spec
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> removeNoteProposedModificationsPreview [
	<gtExample>
	| map spec preview |
	spec := self removeNote.
	map := spec wardleyMap.
	preview := spec proposedModificationsInPreview.
	self assert: preview nodes size equals: map nodes size.
	self assert: preview edges size equals: map edges size.
	self assert: preview notes size equals: 1.
	self assert: preview notes first wardleyMapDecoratorModels size equals: 1.
	^ preview
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> updateEdgeAndNodes [
	<gtExample>
	| map spec previous node1 node2 edge preview |
	previous := self addEdge.
	map := previous wardleyMap.
	spec := GtLLepiterEditWardleyMapSnippetTransformationSpecification new.
	spec
		wardleyMap: map;
		changes: {GtWardleyMapUpdateNodeChangeSpecification new
					nodeId: self node1Id;
					label: '1 - Node'.
				GtWardleyMapUpdateNodeChangeSpecification new
					nodeId: self node2Id;
					label: '2 - Node'.
				GtWardleyMapUpdateEdgeChangeSpecification new
					fromNodeId: self node1Id;
					toNodeId: self node2Id;
					label: '1-2 Edge'}.
	spec changeObject execute.
	node1 := map nodes first.
	self assert: node1 label equals: '1 - Node'.
	self assert: node1 evolution equals: 0.125.
	self assert: node1 visibility equals: 0.25.
	node2 := map nodes last.
	self assert: node2 label equals: '2 - Node'.
	self assert: node2 evolution equals: 0.375.
	self assert: node2 visibility equals: 0.5.
	edge := map edges first.
	self assert: edge label equals: '1-2 Edge'.
	self assert: edge fromNode equals: node1.
	self assert: edge toNode equals: node2.
	preview := spec highlightedModificationsInPreview.
	self assert: preview nodes size equals: map nodes size.
	self assert: preview edges size equals: map edges size.
	self assert: preview notes size equals: map notes size.
	preview nodes
		do: [ :each | self assert: each wardleyMapDecoratorModels size equals: 1 ].
	self assert: preview edges first wardleyMapDecoratorModels size equals: 1.
	^ spec
]

{ #category : #examples }
GtLLepiterEditWardleyMapSnippetTransformationSpecificationExamples >> updateNote [
	<gtExample>
	| map spec previous preview note |
	previous := self addNote.
	map := previous wardleyMap.
	spec := GtLLepiterEditWardleyMapSnippetTransformationSpecification new.
	spec
		wardleyMap: map;
		changes: {GtWardleyMapUpdateNoteChangeSpecification new
					noteId: self noteId;
					label: '1 - Note'}.
	spec changeObject execute.
	note := map notes first.
	self assert: note label equals: '1 - Note'.
	self assert: note evolution equals: 0.5.
	self assert: note visibility equals: 0.75.
	preview := spec highlightedModificationsInPreview.
	self assert: preview nodes size equals: map nodes size.
	self assert: preview edges size equals: map edges size.
	self assert: preview notes size equals: map notes size.
	self assert: preview notes first wardleyMapDecoratorModels size equals: 1.
	^ spec
]
