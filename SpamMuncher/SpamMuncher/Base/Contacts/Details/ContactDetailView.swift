//
//  ContactDetailView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI
import MunchUI

import SwiftUI

struct ContactDetailView: View {
    @ObservedObject var viewModel: ContactDetailViewModel

    var body: some View {
        ZStack {
            BackgroundGradientView()
            mainContent
        }
    }

    private var profileImage: some View {
        ZStack {
            if let image = viewModel.contact.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.red, lineWidth: 2))

            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.red, lineWidth: 2))
            }
        }
    }

    private var buttonStack: some View {
        HStack(spacing: 20) {
            Button(action: viewModel.callContact) {
                Image(systemName: "phone.fill")
                    .font(.largeTitle)
            }
            Button(action: viewModel.messageContact) {
                Image(systemName: "message.fill")
                    .font(.largeTitle)
            }
            Button(action: viewModel.blockOrUnblockContact) {
                Image(systemName: viewModel.isContactBlocked ? "shield.slash.fill" : "shield.fill")
                    .font(.largeTitle)
            }
        }
    }
}

private extension ContactDetailView {
    var mainContent: some View {
        VStack(spacing: 20) {
            profileImage
            Text(viewModel.contact.name)
                .font(.title)
                .fontWeight(.bold)
            Text(viewModel.contact.phoneNumber)
                .font(.headline)
            buttonStack
            Spacer()
        }
        .padding()
    }
}
