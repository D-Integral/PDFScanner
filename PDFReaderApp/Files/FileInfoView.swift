//
//  FileInfoView.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 07/01/2024.
//

import UIKit

class FileInfoView: UIView {
    
    struct Constants {
        struct Thumbnail {
            static let size = CGSize(width: 45, height: 56)
        }
        
        struct TitleLabel {
            static let fontSize = 14.0
        }
        
        struct InfoLabel {
            static let fontSize = 11.0
        }
        
        
        struct Layout {
            static let stackViewSpacing = 5.0
        }
    }
    
    var thumbnail: UIImage? = nil {
        didSet {
            thumbnailImageView.image = thumbnail
        }
    }
    
    private let mainStackView = UIStackView(frame: .zero)
    private let infoStackView = UIStackView(frame: .zero)
    private let thumbnailImageView = UIImageView()
    private let documentTitleLabel = UILabel()
    private let documentInfoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func update(withFile file: DiskFile?) {
        guard let file = file else {
            thumbnail = nil
            documentTitleLabel.text = nil
            documentInfoLabel.text = nil
            return
        }
        
        documentTitleLabel.text = file.name
        documentInfoLabel.text = file.info()
    }
    
    private func setup() {
        setupDocumentTitleLabel()
        setupDocumentInfoLabel()
        setupInfoStackView()
        setupMainStackView()
        
        addSubview(mainStackView)
        
        setupConstraints()
    }
    
    private func setupDocumentTitleLabel() {
        documentTitleLabel.numberOfLines = 2
        documentTitleLabel.textColor = .colourDocumentTitle
        documentTitleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontSize)
        documentTitleLabel.textAlignment = .left
    }
    
    private func setupDocumentInfoLabel() {
        documentInfoLabel.numberOfLines = 1
        documentInfoLabel.textColor = .colourDocumentInfo
        documentInfoLabel.font = .systemFont(ofSize: Constants.InfoLabel.fontSize)
        documentInfoLabel.textAlignment = .left
    }
    
    private func setupInfoStackView() {
        infoStackView.axis = .vertical
        infoStackView.addArrangedSubview(documentTitleLabel)
        infoStackView.addArrangedSubview(documentInfoLabel)
        infoStackView.spacing = Constants.Layout.stackViewSpacing
    }
    
    private func setupMainStackView() {
        mainStackView.axis = .horizontal
        mainStackView.addArrangedSubview(thumbnailImageView)
        mainStackView.addArrangedSubview(infoStackView)
        mainStackView.spacing = Constants.Layout.stackViewSpacing
    }
    
    private func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.widthAnchor.constraint(equalToConstant: Constants.Thumbnail.size.width).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: Constants.Thumbnail.size.height).isActive = true
        
        documentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        documentTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        documentTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        documentInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        documentInfoLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        documentInfoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
