Class {
	#name : #GtWardleyMapNodePropertiesChangeSpecification,
	#superclass : #GtWardleyMapNodeChangeSpecification,
	#instVars : [
		'evolution',
		'color',
		'labelCoordinate',
		'isPipelineVisible',
		'isEvolveVisible',
		'pipelineCoordinate',
		'visibility',
		'label',
		'evolvedLabel',
		'evolvedColor',
		'evolvedSize',
		'evolvedEvolution',
		'evolvedLabelCoordinate',
		'isEvolvedLabelVisible'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #changes }
GtWardleyMapNodePropertiesChangeSpecification >> asChangeIn: aWardleyMapModel [
	^ (self changeClass onMap: aWardleyMapModel)
		color: self color;
		evolution: self evolution;
		evolvedColor: self evolvedColor;
		evolvedEvolution: self evolvedEvolution;
		evolvedLabel: self evolvedLabel;
		evolvedLabelCoordinate: self evolvedLabelCoordinate;
		evolvedSize: self evolvedSize;
		id: (UUID gtFromString: nodeId);
		isEvolveVisible: self isEvolveVisible;
		isEvolvedLabelVisible: self isEvolvedLabelVisible;
		isPipelineVisible: self isPipelineVisible;
		label: self label;
		labelCoordinate: self labelCoordinate;
		pipelineCoordinate: self pipelineCoordinate;
		visibility: self visibility;
		yourself
]

{ #category : #changes }
GtWardleyMapNodePropertiesChangeSpecification >> changeClass [
	self subclassResponsibility
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> color [
	^ color
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> color: anObject [
	color := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> colorDescription [
	"<magritteDescription>"
	^ MAColorDescription new
		accessor: #color;
		comment: 'Color of the node'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolution [
	^ evolution
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolution: anObject [
	evolution := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolutionDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #evolution;
		comment: 'The positition of the node on the evoluation axis'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedColor [
	^ evolvedColor
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedColor: anObject [
	evolvedColor := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedColorDescription [
	"<magritteDescription>"
	^ MAColorDescription new
		accessor: #evolvedColor;
		comment: 'Color of the evolved node'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedEvolution [
	^ evolvedEvolution
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedEvolution: anObject [
	evolvedEvolution := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedEvolutionDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #evolvedEvolution;
		comment: 'The positition of the evolved node on the evoluation axis'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedLabel [
	^ evolvedLabel
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedLabel: anObject [
	evolvedLabel := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedLabelCoordinate [
	^ evolvedLabelCoordinate
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedLabelCoordinate: anObject [
	evolvedLabelCoordinate := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedLabelDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #evolvedLabel;
		comment: 'The displayed label for the evolved node'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedSize [
	^ evolvedSize
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedSize: anObject [
	evolvedSize := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> evolvedSizeDescription [
	"<magritteDescription>"
	^ MANumberDescription new
		accessor: #evolvedSize;
		comment: 'The size of the evolved node'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isEvolveVisible [
	^ isEvolveVisible
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isEvolveVisible: anObject [
	isEvolveVisible := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isEvolveVisibleDescription [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #isEvolveVisible;
		comment: 'Is the evolved node visible?'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isEvolvedLabelVisible [
	^ isEvolvedLabelVisible
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isEvolvedLabelVisible: anObject [
	isEvolvedLabelVisible := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isEvolvedLabelVisibleDescription [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #isEvolvedLabelVisible;
		comment: 'Is the evolved node''s label visible?'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isPipelineVisible [
	^ isPipelineVisible
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isPipelineVisible: anObject [
	isPipelineVisible := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> isPipelineVisibleDescription [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #isPipelineVisible;
		comment: 'Is the node''s pipeline visible?'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> label [
	^ label
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> labelCoordinate [
	^ labelCoordinate
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> labelCoordinate: anObject [
	labelCoordinate := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> labelDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #label;
		comment: 'The displayed label for the node'
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> pipelineCoordinate [
	^ pipelineCoordinate
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> pipelineCoordinate: anObject [
	pipelineCoordinate := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> visibility [
	^ visibility
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> visibility: anObject [
	visibility := anObject
]

{ #category : #accessing }
GtWardleyMapNodePropertiesChangeSpecification >> visibilityDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #visibility;
		comment: 'The positition of the node on the vibility axis'
]
