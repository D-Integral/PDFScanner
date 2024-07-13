//
//  MyFilesCollectionViewCell.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/01/2024.
//

import UIKit
import NefertitiFile

class MyFilesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Definitions
    
    struct Constants {
        struct Thumbnail {
            static let size = CGSize(width: 65, height: 90)
            static let inset = -5.0
        }
        
        struct TitleLabel {
            static let fontSize = 14.0
        }
        
        struct InfoLabel {
            static let fontSize = 11.0
        }
        
        struct MoreButton {
            static let height = 12.0
            static let width = 24.0
            static let insets = NSDirectionalEdgeInsets(top: 10.0,
                                                        leading: 20.0,
                                                        bottom: 0.0,
                                                        trailing: 20.0)
        }
    }
    
    // MARK: - Properties
    
    let thumbnailImageView = UIImageView()
    let documentTitleLabel = UILabel()
    let documentInfoLabel = UILabel()
    let moreButton = UIButton(type: .custom)
    
    var moreActionBlock: ((NefertitiFile?) -> ())? = nil
    var thumbnail: UIImage? = nil {
        didSet {
            thumbnailImageView.image = thumbnail
        }
    }
    
    var diskFile: NefertitiFile? {
        didSet {
            update()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        self.diskFile = nil
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    init(diskFile: NefertitiFile? = nil) {
        self.diskFile = diskFile
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.diskFile = nil
        
        super.init(coder: coder)
        
        setupUI()
    }
    
    // MARK: - Public Interface
    
    public func update() {
        guard let diskFile = diskFile else { return }
        
        documentTitleLabel.text = diskFile.title
        documentInfoLabel.text = diskFile.info()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupDocumentTitleLabel()
        setupDocumentInfoLabel()
        setupMoreButton()
        setupThumbnailImageView()
        
        setupConstrains()
    }
    
    private func setupThumbnailImageView() {
        addSubview(thumbnailImageView)
    }
    
    private func setupDocumentTitleLabel() {
        documentTitleLabel.numberOfLines = 2
        documentTitleLabel.textColor = .label
        documentTitleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontSize)
        documentTitleLabel.textAlignment = .center
        
        addSubview(documentTitleLabel)
    }
    
    private func setupDocumentInfoLabel() {
        documentInfoLabel.numberOfLines = 1
        documentInfoLabel.textColor = .secondaryLabel
        documentInfoLabel.font = .systemFont(ofSize: Constants.InfoLabel.fontSize)
        documentInfoLabel.textAlignment = .center
        
        addSubview(documentInfoLabel)
    }
    
    private func setupMoreButton() {
        let moreButtonImage = UIImage(named: "button_more_cell") as UIImage?
        
        moreButton.setImage(moreButtonImage, for: .normal)
        moreButton.addTarget(self,
                             action: #selector(moreAction),
                             for: .touchUpInside)
        moreButton.configuration?.contentInsets = Constants.MoreButton.insets
        
        addSubview(moreButton)
    }
    
    private func setupConstrains() {
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        moreButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        let moreButtonHeight = Constants.MoreButton.height + Constants.MoreButton.insets.top + Constants.MoreButton.insets.bottom
        moreButton.heightAnchor.constraint(equalToConstant: moreButtonHeight).isActive = true
        let moreButtonWidth = Constants.MoreButton.width + Constants.MoreButton.insets.leading + Constants.MoreButton.insets.trailing
        moreButton.widthAnchor.constraint(equalToConstant: moreButtonWidth).isActive = true
        
        documentInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        documentInfoLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        documentInfoLabel.bottomAnchor.constraint(equalTo: moreButton.topAnchor).isActive = true
        documentInfoLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        documentInfoLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        documentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        documentTitleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        documentTitleLabel.bottomAnchor.constraint(equalTo: documentInfoLabel.topAnchor).isActive = true
        documentTitleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        documentTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.widthAnchor.constraint(equalToConstant: Constants.Thumbnail.size.width).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: Constants.Thumbnail.size.height).isActive = true
        thumbnailImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: documentTitleLabel.topAnchor,
                                                   constant: Constants.Thumbnail.inset).isActive = true
    }
    
    // MARK: - Private Functions
    
    @objc private func moreAction() {
        guard let moreActionBlock = moreActionBlock else { return }
        
        moreActionBlock(diskFile)
    }
}
