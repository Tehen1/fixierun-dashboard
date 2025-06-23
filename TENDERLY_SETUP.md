# 🚀 FixieRun Dashboard - Tenderly Virtual TestNet Setup

## Overview

This guide will help you integrate Tenderly Virtual TestNets with your FixieRun Dashboard using Reown AppKit. Your dashboard is built with vanilla JavaScript, so we'll adapt the Next.js setup instructions for your architecture.

## 🛠️ Current Setup

Your FixieRun Dashboard is configured with:
- **Domain**: `App.Fixie.run`
- **Reown AppKit**: Version 1.7.7+
- **Project ID**: `fb1...f18` (replace with your actual ID)
- **Framework**: Vanilla JavaScript (not Next.js)

## 📋 Step-by-Step Setup

### Step 1: Update Your Reown AppKit Configuration

In your `index.html`, find the `APPKIT_CONFIG` section and add your Tenderly Virtual TestNet:

```javascript
// Add this to your APPKIT_CONFIG.networks array
{
    chainId: 73571, // Your custom chain ID from Tenderly
    name: 'Virtual Sepolia',
    currency: 'vETH',
    explorerUrl: 'https://dashboard.tenderly.co/explorer/vnet/your-testnet-id',
    rpcUrl: 'https://virtual.sepolia.rpc.tenderly.co/your-rpc-key',
    testnet: true
}
```

### Step 2: Environment Variables

Create a `.env` file in your project root:

```env
# Tenderly Virtual TestNet Configuration
TENDERLY_VIRTUAL_TESTNET_RPC=https://virtual.sepolia.rpc.tenderly.co/your-rpc-key
TENDERLY_CHAIN_ID=73571
TENDERLY_EXPLORER_URL=https://dashboard.tenderly.co/explorer/vnet/your-testnet-id

# Reown AppKit Configuration  
NEXT_PUBLIC_PROJECT_ID=fb1...f18
```

### Step 3: Update Network Configuration

Since your app uses vanilla JavaScript, update the network configuration directly:

```javascript
// In your APPKIT_CONFIG, replace the commented Virtual TestNet with:
{
    chainId: 73571, // Your actual chain ID
    name: 'Virtual Sepolia',
    currency: 'vETH',
    explorerUrl: 'https://dashboard.tenderly.co/explorer/vnet/6a6910ba-5831-4758-9d89-1f8e3169433f', // Your explorer URL
    rpcUrl: 'https://virtual.sepolia.rpc.tenderly.co/your-actual-key',
    testnet: true,
    iconUrl: 'https://app.fixie.run/tenderly-icon.png' // Optional
}
```

### Step 4: Initialize AppKit with Virtual TestNet

Add this initialization code to your JavaScript:

```javascript
// Initialize Reown AppKit with Tenderly Virtual TestNet support
let appKitModal = null;

function initializeAppKit() {
    if (typeof AppKit !== 'undefined') {
        try {
            appKitModal = AppKit.createAppKit({
                projectId: APPKIT_CONFIG.projectId,
                chains: APPKIT_CONFIG.networks.map(net => net.chainId),
                metadata: APPKIT_CONFIG.metadata,
                themeMode: APPKIT_CONFIG.themeMode,
                themeVariables: APPKIT_CONFIG.themeVariables,
                features: APPKIT_CONFIG.features,
                // Custom network configurations
                networks: APPKIT_CONFIG.networks,
                // Enable Virtual TestNet features
                enableVirtualTestnets: true,
                // Custom RPC configurations
                rpcConfig: APPKIT_CONFIG.networks.reduce((acc, network) => {
                    acc[network.chainId] = network.rpcUrl;
                    return acc;
                }, {})
            });
            
            // Subscribe to network changes
            appKitModal.subscribeChain((chain) => {
                if (chain.id === 73571) {
                    console.log('🧪 Connected to Tenderly Virtual TestNet');
                    updateNetworkStatus('Virtual Sepolia TestNet');
                }
            });
            
            console.log('✅ AppKit with Tenderly Virtual TestNet initialized');
        } catch (error) {
            console.warn('AppKit initialization failed:', error);
        }
    }
}

// Add this to your existing connectWallet function
async function connectWallet() {
    try {
        if (appKitModal) {
            // Use AppKit for enhanced wallet connection
            await appKitModal.open();
            return;
        }
        
        // Fallback to MetaMask...
        // (existing MetaMask code)
    } catch (error) {
        console.log('❌ Wallet connection failed:', error);
    }
}
```

### Step 5: Add Network Switching

Add a network switcher to your UI:

```javascript
// Add network switching functionality
async function switchToVirtualTestnet() {
    if (appKitModal) {
        try {
            await appKitModal.switchNetwork(73571);
        } catch (error) {
            console.error('Failed to switch to Virtual TestNet:', error);
        }
    } else if (window.ethereum) {
        // Fallback for MetaMask
        try {
            await window.ethereum.request({
                method: 'wallet_switchEthereumChain',
                params: [{ chainId: '0x11F3B' }], // 73571 in hex
            });
        } catch (switchError) {
            // Network not added, add it first
            if (switchError.code === 4902) {
                await addVirtualTestnetToMetaMask();
            }
        }
    }
}

async function addVirtualTestnetToMetaMask() {
    try {
        await window.ethereum.request({
            method: 'wallet_addEthereumChain',
            params: [{
                chainId: '0x11F3B', // 73571 in hex
                chainName: 'Virtual Sepolia',
                nativeCurrency: {
                    name: 'Virtual Sepolia Ether',
                    symbol: 'vETH',
                    decimals: 18
                },
                rpcUrls: ['https://virtual.sepolia.rpc.tenderly.co/your-rpc-key'],
                blockExplorerUrls: ['https://dashboard.tenderly.co/explorer/vnet/your-testnet-id']
            }]
        });
    } catch (error) {
        console.error('Failed to add Virtual TestNet to MetaMask:', error);
    }
}
```

### Step 6: Update Your UI

Add a network indicator to show when connected to Virtual TestNet:

```html
<!-- Add this to your header gas price section -->
<div class="hidden sm:flex items-center p-1.5 px-2.5 rounded-full bg-dark-card bg-opacity-70">
    <span class="text-neon-purple mr-1.5 text-sm font-medium" id="network-name">Ethereum</span>
    <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse" id="network-status"></div>
</div>
```

```javascript
// Update network status
function updateNetworkStatus(networkName) {
    const networkNameEl = document.getElementById('network-name');
    const networkStatusEl = document.getElementById('network-status');
    
    if (networkNameEl) {
        networkNameEl.textContent = networkName;
    }
    
    if (networkStatusEl) {
        if (networkName.includes('Virtual')) {
            networkStatusEl.className = 'w-2 h-2 bg-purple-500 rounded-full animate-pulse';
        } else {
            networkStatusEl.className = 'w-2 h-2 bg-green-500 rounded-full animate-pulse';
        }
    }
}
```

## 🧪 Testing Your Setup

### Test Checklist

1. **AppKit Initialization**: Check console for "✅ AppKit with Tenderly Virtual TestNet initialized"
2. **Network Switching**: Test switching to Virtual TestNet
3. **Wallet Connection**: Verify wallet connects to Virtual TestNet
4. **Explorer Links**: Ensure transaction links open in Tenderly explorer
5. **Gas Prices**: Test gas price tracking on Virtual TestNet

### Debug Common Issues

1. **Invalid Chain ID Error**
   ```
   ✅ Verify chainId: 73571 matches your Tenderly setup
   ✅ Check RPC URL is correct
   ✅ Ensure AppKit supports custom chains
   ```

2. **RPC Connection Failed**
   ```
   ✅ Verify your Tenderly Virtual TestNet is running
   ✅ Check RPC URL permissions
   ✅ Test RPC endpoint with curl
   ```

3. **AppKit Not Loading Virtual TestNet**
   ```
   ✅ Ensure AppKit version is 1.7.7+
   ✅ Check network configuration format
   ✅ Verify project ID permissions
   ```

## 🔄 Enhanced Features

### Virtual TestNet Gas Tracking

Add specific gas tracking for your Virtual TestNet:

```javascript
async function fetchVirtualTestnetGas() {
    if (app.user.chainId === 73571) {
        try {
            // Virtual TestNets typically have very low gas
            const virtualGasPrice = {
                slow: 1,
                standard: 2,
                fast: 3
            };
            
            // Update UI with Virtual TestNet gas prices
            document.getElementById('gas-price-display').textContent = `${virtualGasPrice.standard} gwei`;
            document.getElementById('gas-price-status').textContent = 'Virtual TestNet - Ultra Low Fees';
            
        } catch (error) {
            console.error('Error fetching Virtual TestNet gas:', error);
        }
    }
}
```

### Virtual TestNet Faucet Integration

Add a faucet button for getting test tokens:

```javascript
async function requestVirtualTestnetTokens() {
    if (app.user.chainId === 73571 && app.user.walletAddress) {
        try {
            // Simulate faucet request (implement actual faucet logic)
            console.log('🚰 Requesting vETH from faucet...');
            
            showNotification(
                '🚰 Test Tokens Requested', 
                'vETH tokens will be sent to your wallet', 
                'info'
            );
            
        } catch (error) {
            console.error('Faucet request failed:', error);
        }
    }
}
```

## 📱 Mobile Support

Your Virtual TestNet setup will work seamlessly on mobile with AppKit's built-in mobile wallet support.

## 🚀 Deployment

When deploying to `App.Fixie.run`:

1. **Update environment variables** with production values
2. **Configure CORS** for Tenderly endpoints
3. **Add Virtual TestNet** to your Google OAuth authorized origins
4. **Test thoroughly** on your production domain

## 📞 Support

For Tenderly-specific issues:
- [Tenderly Documentation](https://docs.tenderly.co/)
- [Tenderly Discord](https://discord.gg/tenderly)

For AppKit issues:
- [Reown AppKit Documentation](https://docs.reown.com/appkit)
- [Reown Discord](https://discord.gg/reown)

---

**Your FixieRun Dashboard is now ready for advanced blockchain testing with Tenderly Virtual TestNets! 🎉**
