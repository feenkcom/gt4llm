Class {
	#name : #GtWardleyMapUpdateMapChangeSpecification,
	#superclass : #GtWardleyMapChangeSpecification,
	#instVars : [
		'isEvolutionAxisVisible',
		'isTitleVisible',
		'title'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapUpdateMapChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapUpdateMap'
]

{ #category : #changes }
GtWardleyMapUpdateMapChangeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapUpdateMapChange onMap: aWardleyMapModel)
		isEvolutionAxisVisible: isEvolutionAxisVisible;
		isTitleVisible: isTitleVisible;
		title: title;
		yourself
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> isEvolutionAxisVisible [
	^ isEvolutionAxisVisible
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> isEvolutionAxisVisible: anObject [
	isEvolutionAxisVisible := anObject
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> isEvolutionAxisVisibleDescription [
	<magritteDescription>
	
	 ^ MABooleanDescription new
		  accessor: #isEvolutionAxisVisible;
		  comment: 'True if the evolution axis is visible.'
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> isTitleVisible [
	^ isTitleVisible
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> isTitleVisible: anObject [
	isTitleVisible := anObject
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> isTitleVisibleDescription [
	<magritteDescription>
	
	 ^ MABooleanDescription new
		  accessor: #isTitleVisible;
		  comment: 'True if the title is visible.'
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> title [
	^ title
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> title: anObject [
	title := anObject
]

{ #category : #accessing }
GtWardleyMapUpdateMapChangeSpecification >> titleDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #title;
		  comment: 'The title of the Wardley Map. It is only displayed when isTitleVisible is true.'
]
