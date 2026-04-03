Class {
	#name : #GtWardleyMapEdgePropertiesChangeSpecification,
	#superclass : #GtWardleyMapEdgeChangeSpecification,
	#instVars : [
		'label',
		'labelCoordinate',
		'arrow',
		'isLabelVisible',
		'width',
		'color'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> arrow [
	^ arrow
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> arrow: anObject [
	arrow := anObject
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> arrowDescription [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #arrow;
		comment: 'Does the edge have an arrow?'
]

{ #category : #changes }
GtWardleyMapEdgePropertiesChangeSpecification >> asChangeIn: aWardleyMapModel [
	^ (self changeClass onMap: aWardleyMapModel)
		fromNodeId: (UUID gtFromString: fromNodeId);
		toNodeId: (UUID gtFromString: toNodeId);
		arrow: self arrow;
		color: self color;
		isLabelVisible: self isLabelVisible;
		label: self label;
		labelCoordinate: self labelCoordinate;
		width: self width;
		yourself
]

{ #category : #changes }
GtWardleyMapEdgePropertiesChangeSpecification >> changeClass [
	self subclassResponsibility
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> color [
	^ color
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> color: anObject [
	color := anObject
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> colorDescription [
	"<magritteDescription>"
	^ MAColorDescription new
		accessor: #color;
		comment: 'Color of the edge'
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> isLabelVisible [
	^ isLabelVisible
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> isLabelVisible: anObject [
	isLabelVisible := anObject
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> isLabelVisibleDescription [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #isLabelVisible;
		comment: 'Is the edge''s label visible?'
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> label [
	^ label
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> labelCoordinate [
	^ labelCoordinate
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> labelCoordinate: anObject [
	labelCoordinate := anObject
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> labelDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #label;
		comment: 'The displayed label for the edge'
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> width [
	^ width
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> width: anObject [
	width := anObject
]

{ #category : #accessing }
GtWardleyMapEdgePropertiesChangeSpecification >> widthDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #width;
		comment: 'The width of the edge'
]
